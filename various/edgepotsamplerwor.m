function [varargout] = edgepotsamplerwor( pwpot, st)
% function [m] = edgepotsampleswor( pwpot, st )
% Returns a set of particles sampled from a symmetric edge potential
% phi( \theta_j - \theta_i ) over the edge (i,j) in the earth coordinate
% frame. This is carried out by generating samples from a Kernel Density 
% Estimate of phi( \theta_j - \theta_i )
% where st are the location and orientation samples from the local
% (parameter) belief distribution

% Murat Uney 01.12.2017



numSamples = st.getnumpoints;
if nargin>=3
    numSamples = varargin{1};
end

if isa(pwpot,'gk')
    % Generate samples from the edge potential variable and find the kde
    p = pwpot.gensamples( numSamples );
    w = pwpot.evaluate( p );  
elseif isa(pwpot,'particles')
    p = pwpot.sample( numSamples );
    w = pwpot.evaluate( p );  
else
    error('Objects of class %s not handled!', class( pwpot) );
end

% The respective positions and orientations are with respect to the local
% frame. Convert them to the Earth frame.
for k=1:numSamples
    s_iE = st.states([1:2],k);
    alpha_i = st.states(3,k);
    
    s_jiL = p([1:2],k);
    alpha_jfromi = p(3,k);
    
    R_LE = dcm( alpha_i*pi/180, 0, 0 );
    R_RL = dcm( alpha_jfromi*pi/180, 0, 0 );
    
    R_RE = R_RL*R_LE;
    
    s_jiE = (R_LE([1:2],[1:2]))'*s_jiL;
    s_jE = s_iE + s_jiE;
    
    [alpha_j, th_j, phi_j ] = idcm( R_RE );
    
    p([1,2],k) = s_jE;
    p(3,k) = alpha_j*180/pi;
end


varargout{1} = p; % m;
if nargout >=2
    varargout{2} = w;
end


