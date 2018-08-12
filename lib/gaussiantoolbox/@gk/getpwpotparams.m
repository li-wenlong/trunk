function p = getpwpotparams( p_x, E, varargin )
% p = getpwpotparams( p_x, E )
% Returns gk objects capturing p(x_1,p_x2), p(x_1) p(x_2)
% to evaluate the edge potential of a pairwise MRF given by
% p(x_1, x_2)/(p(x_1)p(x_2))
% These objects will be evaluated to test the particle BP with a Gaussian MRF
 
% Murat Uney 01.02.2014

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
    
    [C_p, mu_p ] = gaussmarg( p_x.C , [ind1;ind2]', p_x.m );
    params.jointdist = cpdf( gk( C_p, mu_p ) );
    
    % Find the rescaling factors p(x_i) and p(x_j)
    % This does not lead to nicely bell shaped (positive def. matrices
    % for) edge potentials either
    [C_i, mu_i ] = gaussmarg( p_x.C , ind1, p_x.m );
    [C_j, mu_j ] = gaussmarg( p_x.C , ind2, p_x.m );
    params.localmarg  = cpdf( gk( C_i, mu_i ) );
    params.neimarg = cpdf( gk( C_j, mu_j ) );
    
   p{i} = params;
    
end

    
    