function d = wasserstein2( a, b)

if ~isa( a, 'gk' )
    error('The first argument should be a gk object');
else
    if length(a)>1
        error('The first argument should be a single object');
    end
end

if isa( b, 'gk')
    c = b;
else
    error('The second argument should be an array of gk objects.')
end

d = zeros(size(b));
for i=1:length(b(:))
    d(i) = was2distfun(a, b(i));
end

function d = was2distfun(a,b)

sqSigmai = sqrtm(a.C);

w2square = norm(b.m-a.m,2)^2 + trace( a.C ) + trace( b.C ) ...
    - 2*trace( sqrtm( sqSigmai*b.C*sqSigmai )   );

d = sqrt( w2square );
    