function p = getsymedgepots( p_x, E, varargin )
% p = getsymedgepots( p_x, E )
% Returns a gk objects capturing psi(x_1,x_2) \propto p(x_1 - x_2)
% to evaluate the edge potential of a pairwise MRF with node and edge 
% marginals given by p(x_1, x_2), p(x_1) and p(x_2)
% These objects will be evaluated to test the particle BP with a Gaussian MRF
%

% Murat Uney 07.05.2017

dims = ones(1, size( p_x.C, 1) )';
if nargin>2
    dims = varargin{1}(:);
    if length( dims ) == 1
       dims = dims* ones(1, size( p_x.C, 1) )'; 
    end
end

stind = [1;cumsum( dims )+1];

V = unique( E(:) ,'stable');
for i=1:size( E ,1)
    ind1 = [stind( E(i,1) ):stind( E(i,1) )+dims( E(i,1) ) - 1  ]';
    ind2 = [stind( E(i,2) ):stind( E(i,2) )+dims( E(i,2) ) - 1  ]';
    
    [C_12, mu_12 ] = gaussmarg( p_x.C , [ind1,ind2]', p_x.m ); % Find the marginal p(x_1)
    ind1t = [1:length(ind1)];
    ind2t = [length(ind1t)+1:length(ind1t)+ length(ind2)];
    
    C_p = C_12( ind1t, ind1t ) + C_12( ind2t, ind2t ) - C_12( ind1t, ind2t) - C_12( ind2t, ind1t );
    
    
    p{i} = cpdf( gk( C_p, p_x.m(ind2)-p_x.m(ind1) ) );
end

    
    