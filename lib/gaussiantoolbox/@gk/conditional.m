function [p_c] = conditional( p, varargin )
% this method returns the required conditional of the joint Gaussian p
% as a single quadratic exponential (i.e., a Gaussian kernel)
% Note that p(x) = N(x; mu, C_x)
%
%   [ p_m ] = p.marginalise() 
%   returns the model with information matrix of p( x_1 ) 
%   considering the joint N(x; p.C, p.m ) where 0 is the zero vector.
%
%   [C_p, mu_p ] = p.marginalise( p_ind ) 
%   returns the covariance
%   matrix of p( x_p ) where x_p = [x_j]_{j \in p_ind} considering the joint 
%   N(x;  p.C, p.m  ).
%

% Murat Uney

N = length(p.m);

if nargin >= 2
    q_ind = unique( varargin{1}(:) , 'stable');
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

lenP = N - lenQ;

[C_pGq, Lambda_pq ] = gausscondquad( p.C, q_ind );

p_c = gk( eye(N), p.m, 1/( ((2*pi)^(lenP/2) )*det(C_pGq)^(1/2) )  );
p_c.S = Lambda_pq;
