function [ml] = mlstate( this, obs )

Zs = obs.Z;

pstate = obs.pstate;
sstate = obs.sstate;

if this.insensorframe == 0
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
    
    % Get the state of the sensor in Earth coordinates
    sstateE = pcs2ecs( pstate, sstate );
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
    
     % In the sensor coordinate system, the x y position of the sensor is
     % the origin
    sstateE.state = [0 0]';
end

T = R_SB*R_BE; % Earth to Sensor
T = T([1:2],[1:2]);

H = this.linTrans;
R = this.noiseCov;

H_E = T'*H*T;
R_E = T'*R*T;


iH = inv( H_E );

obsObj = obs.Z;
for zcnt = 1:length(obsObj)
    Za = obsObj(zcnt).Z;
    
    X_sE = sstateE.state ;
    
    ml(zcnt) = cpdf( gk( iH*R_E*iH', iH*T'*Za + X_sE ) );
end