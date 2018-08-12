function [varargout] = gausscondinf( Lambda_x, varargin )
%GAUSSCONDINF returns information parameters of the required conditional
% distribution given the inverse correlation matrix of the joint.
% Note that x ~ N( C_x, mu ) => x ~ N^(-1)( Lambda, nu )
% where Lambda = C_x^(-1) and nu = Lambda*mu
%
% For the case, it also holds that p(x_p|x_q) = N(x_p; C_p|q, mu_p|g = a + Bx_q )
% where a is a vector given by mu_p + Lambda_11^(-1)*Lambda_12*mu_q where
% Lambda_x = [ Lambda_11, Lambda_12; Lambda_21, Lambda_22]
%
%   [Lambda_pGq ] = gausscondinf( Lambda_x ) returns the information
%   parameters of p( x_1 | x_2 = 0,..., x_N = 0 ) considering the joint
%   N^(-1)(Lambda, nu) with Lambda = Lambda_x and nu = 0 in which case
%   nu_pGq is identicaly zero, i.e. the posterior is N^(-1)(Lambda_pGq, 0).
%
%   [Lambda_pGq ] = gausscondinf( Lambda_x, q_ind ) returns the
%   information parameters of p( x_p | x_q = 0 ) where 
%   x_q = [x_j]_{j \in q_ind} considering the joint N^(-1)(Lambda, nu)
%   with Lambda = Lambda_x and nu = 0 in which case nu_pGq is identicaly 
%   zero, i.e. the posterior is N^(-1)(Lambda_pGq, 0).
%
%   [Lambda_pGq, nu_pGq ] = gausscondinf( Lambda_x, q_ind, nu_x ) returns the
%   information parameters of p( x_p | x_q = 0 ) where 
%   x_q = [x_j]_{j \in q_ind} considering the joint N^(-1)(Lambda, nu) 
%   with Lambda = Lambda_x and nu = nu_x and x_q = 0, i.e. the posterior
%   is N^(-1)(Lambda_pGq, nu_pGq).
%
%   [Lambda_pGq, nu_pGq ] = gausscondinf( Lambda_x, q_ind, nu_x, q_val ) returns the
%   information parameters of p( x_p | x_q = q_val ) where 
%   x_q = [x_j]_{j \in q_ind} considering the joint N^(-1)(Lambda, nu) 
%   ith Lambda = Lambda_x and nu = nu_x and x_q =  q_val, i.e. the posterior
%   is  N^(-1)(Lambda_pGq, nu_pGq).
%
%   See also GAUSSMARGINF, GAUSSCOND, GAUSSMARG, GEOGMRF, GGM, GKLD
%
%

% Murat Uney

if nargin<1
    error('Not enough input arguments!');
end

if ~isnumeric(Lambda_x)
    error('First argument should be a square numerical matrix!');
else
    if ndims( Lambda_x )~=2
        error('First argument should be a square matrix!');
    else
        [N, M] = size(Lambda_x);
        if N~= M
            error('First argument should be a SQUARE matrix!');
        end
    end
end


if nargin >= 2
    q_ind = unique( varargin{1}(:), 'stable' );
    if ~isnumeric(q_ind)
        error('The second argument should be an index array of type numeric');
    end
    if ~isempty( find( q_ind<1 | q_ind>N ) ) | length(q_ind)>=N
        error('The index array contains entries that exceeds 1,...,N');
    end
    lenQ = length( q_ind );
else
    q_ind = [2:N]';
    lenQ = N-1;
end

if nargin>=3
    nu_x = varargin{2}(:);
    if ~isnumeric( nu_x )
        error('The third argument should be a numeric array holding nu_x of the joint dist.!');
    end
    if length(nu_x)~=N
        error('nu_x should be of length in accordance with Lambda_x!');
    end
else
    nu_x = zeros( N, 1); 
end

if nargin == 4
    q_val = varargin{3}(:);
    if ~isnumeric( q_val ) & ~strcmp( class(q_val), 'sym')
        error('The fourth argument should be a numeric array holding q_val or a symbolic one!');
    end
    if length( q_val )~= lenQ
        error('q_val should be of length in accordance with q_ind' );
    end
else
    q_val = zeros( lenQ, 1);
end

% Find the indexes of the p side
p_ind =  setdiff( [1:N]', q_ind);
lenP = length(p_ind);
% Now reorder the variable entries such that x = [x_p , x_q]';
E = eye(N);
E = E( [p_ind;q_ind],:);
Lambda_pq = E*Lambda_x*E';

Lambda_11 = Lambda_pq(1:lenP,1:lenP);
Lambda_12 = Lambda_pq(1:lenP, lenP+1:N );
Lambda_21 = Lambda_pq(lenP+1:N, 1:lenP );
Lambda_22 = Lambda_pq(lenP+1:N,lenP+1:N );

Lambda_pGq = Lambda_11;

varargout{1} = Lambda_pGq;
if nargout == 1
    return;
end

nu_pGq = nu_x(p_ind)- Lambda_12*q_val;
varargout{2} = nu_pGq;

    

    
    
    