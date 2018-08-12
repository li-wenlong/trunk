function varargout = brownianstep( these, varargin )
% This method adds a Brownian motion step to the states with homogenous 
% variance along all directions.


svar = 1; % step variance

if nargin>=2
    svar = varargin{1}(1);
end

C = wcov( these.states, these.weights );
% Find the eigen decomposition of C = VDV'
[V,D] = eig( C );

% Scale the covariance to find that of the Brownian step
Ctilde = svar*C/trace(D);
% Find the linear transform to convert unit Gaussians to the above Brownian
%  steps
R = chol( (Ctilde + Ctilde' )/2 )';

[nx Np] = size( these.states );
xdim = nx;

gauss_mat = randn(nx,Np);

these.states = these.states + R*gauss_mat;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end
