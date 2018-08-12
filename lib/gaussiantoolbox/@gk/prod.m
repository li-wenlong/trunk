function b = prod(a)

b = a(1);
for i=2:length(a)
    b = b*a(i);
end