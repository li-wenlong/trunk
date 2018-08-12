function d = entropy( a)

if ~isa( a, 'gk' )
    error('The first argument should be a gk object');
else
    if length(a)>1
        error('The first argument should be a single object');
    end
end


d = zeros(size(a));
for i=1:length(a(:))
    d(i) = entfun(a(i));
end

function d = entfun(a)

k = length(a.m);
d = k/2*(1+log(2*pi)) + 1/2*log( det(a.C) );
% d = k/2 - log(a.Z);
% Note that
% a.Z = 1/( ((2*pi)^(dim/2) )*det(a.C)^(1/2) )