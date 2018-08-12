function [I_E, H_E, R_E, T ] = innovations( this, obs, m_pred, varargin )

if nargin == 4
    obsval = varargin{1}.Z;
else
    obsval = obs.Z(1).Z;
end

pstate = obs.pstate;
sstate = obs.sstate;

if this.insensorframe == 0
    %plocE = pstate.getstate({'x','y','z'});
    %angBE = pstate.getstate({'psi','theta','phi'});
    
    % To make it work faster:
    plocE = pstate.location;
    angBE = pstate.orientation;
    
    R_BE = dcm(angBE);
    
    %slocB = sstate.getstate({'x','y','z'});
    %angSB = sstate.getstate({'psi','theta','phi'});
    
    slocB = sstate.location;
    angSB = sstate.orientation;
    
    R_SB = dcm( angSB );
    
    ploc = pstate.location;
    sloc = sstate.location;
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
    
    
    ploc = pstate.location*0;
    sloc = sstate.location*0;
end

% Pred in ECS, covert it to SCS


% Sources received in the ECS ; find them in the SCS
losE = [m_pred([1,2]);0] - (ploc + R_BE'*sloc);
velE = [m_pred([3,4]);0];

losS = R_SB*R_BE*losE;
velS = R_SB*R_BE*velE;
% Steer the covariance matrix
T = R_SB*R_BE; % Earth to Sensor
T = T([1:2],[1:2]);
%TT = blkdiag(T,T); % Rotate both the position and the velocity
TT = [ T, zeros(2); zeros(2), T];


%C_S = T*C_pred*T'; % C_pred in the sensor coordinate system

% Get the likelihood matrices for all measurements
H = this.linTrans;
R = this.noiseCov;

H_E = T'*H*T;
R_E = T'*R*T;

I =  obsval - H*[losS([1,2])];%velS([1,2])];
I_E = T'*I;
