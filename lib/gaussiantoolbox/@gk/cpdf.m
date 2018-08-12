function b = cpdf(a)

b = a;
if isempty( b )
    return;
end

dim = getdims(b);
for i = 1:length(b(:))
    b(i).Z = 1/( ((2*pi)^(dim/2) )*det(b(i).C)^(1/2) );
end
    