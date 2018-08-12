function [p_m] = marginalise( p, varargin )
% this method returns the required marginal of the joint Gaussian p
% Note that p(x) = N(x; mu, C_x)
%
%   [ p_m ] = p.marginalise() 
%   returns the model with covariance matrix of p( x_1 ) 
%   considering the joint N(x; p.C, p.m ) where 0 is the zero vector.
%
%   [C_p, mu_p ] = p.marginalise( p_ind ) 
%   returns the covariance
%   matrix of p( x_p ) where x_p = [x_j]_{j \in p_ind} considering the joint 
%   N(x;  p.C, p.m  ).
%

% Murat Uney

N = length(p.m);

if nargin >= 1
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


if nargin >= 4
    error('Max. number of input arguments is 3!');
end

% the function below accepts p_ind as entries to remain after
% marginalisation
[C_p, mu_p ] = gaussmarg( p.C, p_ind, p.m );

p_m = cpdf( gk( C_p, mu_p ) );
