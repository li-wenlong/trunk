function c = rdivide(a,b)

if abs( sum( size(a)-size(b)))~= 0
    error('In an expression a./b, a and b should be of the same size.');
end
if isa( a, 'gk' )
    c = a;
elseif isa( b, 'gk')
    c = b;
end

for i=1:length(a(:))
    c(i) = a(i)/b(i);
end