function [varargout] = gaussmarg( C_x, varargin )
%GAUSSMARG returns parameters (covariance matrix and mean vector) of the
% required marginal, given those of the joint.
% Note that p(x) = N(x; mu, C_x)
%
%   [C_p ] = gaussmarg( C_x ) returns the covariance matrix of p( x_1 ) 
%   considering the joint N(x; C_x, mu = 0 ) where 0 is the zero vector.
%
%   [C_p ] = gaussmarg( C_x, p_ind ) returns the covariance matrix of
%   p( x_p ) where x_p = [x_j]_{j \in p_ind} considering the joint 
%   N(x; C_x, mu = 0 ) where 0 is the zero vector.
%
%   [C_p, mu_p ] = gaussmarg( C_x, p_ind, mu_x ) returns the covariance
%   matrix of p( x_p ) where x_p = [x_j]_{j \in p_ind} considering the joint 
%   N(x; C_x, mu = mu_x ).
%
%
%   See also GAUSSCOND, GAUSSMARGINF, GAUSSCONDINF, GEOGMRF, GGM, GKLD
%

% Murat Uney

if nargin<1
    error('Not enough input arguments!');
end

if ~isnumeric(C_x)
    error('First argument should be a square numerical matrix!');
else
    if ndims( C_x )~=2
        error('First argument should be a square matrix!');
    else
        [N, M] = size(C_x);
        if N~= M
            error('First argument should be a SQUARE matrix!');
        end
    end
end


if nargin >= 2
    p_ind = unique( varargin{1}(:), 'stable' );
    if ~isnumeric(p_ind)
        error('The second argument should be an index array of type numeric');
    end
    if ~isempty( find( p_ind<1 | p_ind>N ) ) | length(p_ind)>N
        error('The index array contains entries that exceeds 1,...,N');
    end
    lenP = length( p_ind );
else
    p_ind = 1';
    lenP = 1;
end

if nargin==3
    mu_x = varargin{2}(:);
    if ~isnumeric( mu_x )
        error('The third argument should be a numeric array holding nu_x of the joint dist.!');
    end
    if length(mu_x)~=N
        error('nu_x should be of length in accordance with Lambda_x!');
    end
else
    mu_x = zeros( N, 1); 
end

if nargin >= 4
    error('Max. number of input arguments is 3!');
end
R = chol(C_x);
Rinv = R^(-1);

Lambda_x = Rinv*Rinv';
nu_x = Lambda_x*mu_x;

% Find the indexes of the p side
q_ind =  setdiff( [1:N]', p_ind);
lenQ = length(q_ind);
% Now reorder the variable entries such that x = [x_p , x_q]';
E = eye(N);
E = E( [p_ind;q_ind],:);
Lambda_pq = E*Lambda_x*E';

Lambda_11 = Lambda_pq(1:lenP,1:lenP);
Lambda_12 = Lambda_pq(1:lenP, lenP+1:N );
Lambda_21 = Lambda_pq(lenP+1:N, 1:lenP );
Lambda_22 = Lambda_pq(lenP+1:N,lenP+1:N );

R = chol(Lambda_22);
Rinv = R^(-1);

Lambda_22inv = Rinv*Rinv';

Lambda_p = Lambda_11 - Lambda_12*Lambda_22inv*Lambda_21;

R = chol(Lambda_p);
Rinv = R^(-1);

C_p = Rinv*Rinv';

varargout{1} = C_p;
if nargout == 1
    return;
end

nu_p = nu_x(p_ind)- Lambda_12*Lambda_22inv*nu_x(q_ind);
mu_p =  C_p*nu_p;
varargout{2} = mu_p;
