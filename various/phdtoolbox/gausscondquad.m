function [C_pGq, Lambda_pq] = gausscondquad( C_x, varargin )
% GAUSSCONDQUAD returns parameters in the form of two covariance matrices 
% to represent the required conditional as a single quadratic exponential.
%
% For the case, the joint mean will remain as is in the quadratic expression 
% and the conditional density is given as follows:
% p(x_p|x_q) = (2*pi)^(d/2)(C_pGq)^(-1/2) exp( ( [p;q]-[mu_p;mu_q] )^T L_pq ( [p;q]-[mu_p;mu_q] ) )
% where given C_x^(-1) = [ L_11, L_12; L_21, L_22 ];
% C_pGq^(-1) = L_11^(-1);
% L_pq = C_pq^(-1) = [L_11, L_12; L_21 L_21 L_11^(-1) L_12 ];
%
%   [C_pGq, L_pq ] = gausscondquad( C_x ) returns the parameters of 
%   p( x_1 | x_2 , ... , x_N )
%
%   [C_pGq, L_pq ] = gausscondquad( C_x, q_ind ) returns the parameters of 
%   p( x_p | x_q ) where x_q = [x_j]_{j \in q_ind} 
%
%   See also GAUSSCOND, GAUSSMARG, GAUSSCONDINF, GAUSSMARGINF, GEOGMRF, GGM, GKLD
%
%

% Murat Uney

if nargin<1
    error('Not enough input arguments!');
end
if nargout ~= 2
    error('Please demand 2 outputs!');
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

R = chol(C_x);
Rinv = R^(-1);

Lambda_x = Rinv*Rinv';
%nu_x = Lambda_x*mu_x;

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

Lambda_pq = [Lambda_11, Lambda_12; Lambda_21,Lambda_21*C_pGq*Lambda_12 ];

   