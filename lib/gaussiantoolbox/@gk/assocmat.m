function [A, varargout ] = assocmat( xs, Z, varargin )
% This function returns the association matrix for N states and
% M measurements which has in its (i,j) the field, the log likelihood of
% measuring jthe observation given the ith state distribution.
% [A] = assocmat( x, Z, H, R) returns log-likelihood matrix A given N @gk
% objects encapsulating the states, an dz x M measurement matrix Z each
% column of which is modelled as Z(:,i) = Hx+n with n ~ N( 0, R^1/2)
% [A, pz] = assocmat( x, Z, H, R) also gets the measurement distributions
% for elements of x in the Gaussian Kernel @gk array pz.

% Murat Uney 16.06.2017


% Find the dimensionality of the measurements
dz = size( Z, 1 ); 

% Find the dimensionality of the states
dx = xs(1).getdims;
% Default selections for H and R
H = [ eye(dz), zeros( dz, dx - dz ) ];
R = eye(dz);

if nargin>=3
   H = varargin{1};
   if ~isequal( size(H,1), [dz] )
       error('H must have dz rows');
   end
   H = [H, zeros(dz, dx - size(H,2))];
end

if nargin>=4
    R = varargin{2};
    if ~isequal( size(R), [dz,dz] )
        error('R must be a square matrix of size dz x dz');    
    end
end

% number of states
N = length( xs );

% number of measurements
M = size( Z, 2 );

% likelihood function for each state as a @gk
pz = gk([]);

% log likelihood array
A = -inf( N, M );


for i=1:N
    pz(i) = measdist( xs(i), H, R );
    for j=1:M
       A(i,j) = pz(i).evaluatelog( Z(:,j) );
    end
end

if nargout>=2
    varargout{1} = pz;
end






