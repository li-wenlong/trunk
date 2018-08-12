function [varargout] = gaussmarginf( Lambda_x, varargin )
%GAUSSMARGINF returns information parameters of the required marginal
% distribution given the inverse correlation matrix of the joint.
% Note that x ~ N(mu, C_x) => x ~ N^(-1)( nu, Lambda)
% where Lambda = C_x^(-1) and nu = Lambda*mu
%
%   [Lambda_p ] = gaussmarginf( Lambda_x ) returns the information
%   parameters of p( x_1 ) considering the joint N^(-1)(Lambda, nu) 
%   with Lambda = Lambda_x and nu = 0 in which case nu_p is identicaly 
%   zero, i.e. the required marginal is N^(-1)(Lambda_p, 0).
%
%   [Lambda_p ] = gaussmarginf( Lambda_x, p_ind ) returns the
%   information parameters of p( x_p ) where x_p = [x_j]_{j \in p_ind} 
%   considering the joint N^(-1)(Lambda, nu)
%   with Lambda = Lambda_x and nu = 0 in which case nu_p is identicaly 
%   zero, i.e. the required marginal is N^(-1)(Lambda_p, 0).
%
%   [Lambda_p, nu_p ] = gaussmarginf( Lambda_x, p_ind, nu_x ) returns the
%   information parameters of p( x_p ) where 
%   x_p = [x_j]_{j \in p_ind} considering the joint N^(-1)(Lambda, nu) 
%   with Lambda = Lambda_x and nu = nu_x, i.e. the required marginal is
%   N^(-1)(Lambda_p, nu_p).
%
%
%   See also GAUSSCONDINF, GAUSSMARG, GAUSSCOND, GEOGMRF, GGM, GKLD
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

if nargin >= 4
    error('Max. number of input arguments is 3!');
end

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

Lambda_p = Lambda_11 - Lambda_12*Lambda_22^(-1)*Lambda_21;

varargout{1} = Lambda_p;
if nargout == 1
    return;
end

nu_p = nu_x(p_ind)- Lambda_12*Lambda_22^(-1)*nu_x(q_ind);
varargout{2} = nu_p;

    

    
    
    