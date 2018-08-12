function [varargout] = gausscond( C_x, varargin )
%GAUSSCOND returns the parameters (covariance matrix and the mean vector)
% of the required conditional distribution given the those of the joint.
%
% For the case, it also holds that p(x_p|x_q) = N(x_p; C_p|q, mu_p|g = a + Bx_q )
% where a is a vector given by mu_p + Lambda_11^(-1)*Lambda_12*mu_q where
% Lambda_x = [ Lambda_11, Lambda_12; Lambda_21, Lambda_22]
%
%   [C_pGq ] = gausscond( C_x ) returns the parameters of 
%   p( x_1 | x_2 = 0,..., x_N = 0 ) considering the joint
%   N(C_x, mu = 0 ) where 0 is the zero vector and hence 
%   nu_pGq is identicaly zero, i.e. the conditional is N(C_pGq, 0).
%
%   [C_pGq ] = gausscond( C_x, q_ind ) returns the parameters of 
%   p( x_p | x_q = 0 ) where x_q = [x_j]_{j \in q_ind} considering the 
%   joint N(C_x, mu = 0 ) where 0 is the zero vector in which case nu_pGq 
%   is identicaly zero, i.e. the conditional is N^(-1)(C_pGq, 0).
%
%   [C_pGq, mu_pGq ] = gausscond( C_x, q_ind, mu_x ) returns the
%   parameters of p( x_p | x_q = 0 ) where x_q = [x_j]_{j \in q_ind} 
%   considering the joint N(C_x, mu = mu_x ),
%   i.e. the posterior is N(Lambda_pGq, mu_pGq).
%
%   [C_pGq, mu_pGq ] = gausscond( C_x, q_ind, mu_x, q_val ) returns the
%   parameters of p( x_p | x_q = q_val ) where x_q = [x_j]_{j \in q_ind} 
%   considering the joint N(C_x, mu = mu_x), 
%   i.e. the posterior is  N(Lambda_pGq, mu_pGq).
%
%   [C_pGq, mu_pGq, a, B ] = gausscond() returns the parameters a and B where 
%   mu_p|g = a + Bx_q
%
%   See also GAUSSMARG, GAUSSCONDINF, GAUSSMARGINF, GEOGMRF, GGM, GKLD
%
%

% Murat Uney

if nargin<1
    error('Not enough input arguments!');
end
if nargout == 3
    error('Please demand 1,2 or 4 outputs!');
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
    q_ind = unique( varargin{1}(:) , 'stable');
    if ~isnumeric(q_ind)
        error('The second argument should be an index array of type numeric');
    end
    if ~isempty( find( q_ind<1 | q_ind>N ) ) | length(q_ind)>N
        error('The index array contains entries that exceeds 1,...,N');
    end
    lenQ = length( q_ind );
else
    q_ind = [2:N]';
    lenQ = N-1;
end

if nargin>=3
    mu_x = varargin{2}(:);
    if ~isnumeric( mu_x )
        error('The third argument should be a numeric array holding mu_x of the joint dist.!');
    end
    if length(mu_x)~=N
        error('mu_x should be of length in accordance with C_x!');
    end
else
    mu_x = zeros( N, 1); 
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

R = chol(C_x);
Rinv = R^(-1);

Lambda_x = Rinv*Rinv';
nu_x = Lambda_x*mu_x;

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

R = chol(Lambda_pGq);
Rinv = R^(-1);

C_pGq = Rinv*Rinv';

varargout{1} = C_pGq;
if nargout == 1
    return;
end

nu_pGq = nu_x(p_ind)- Lambda_12*q_val;
mu_pGq = C_pGq*nu_pGq;
varargout{2} = mu_pGq;
if nargout == 2
    return;
end
varargout{3} = C_pGq*nu_x(p_ind);
varargout{4} = -C_pGq*Lambda_12;

    

    
    
    