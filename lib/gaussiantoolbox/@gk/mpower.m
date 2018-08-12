function c = mpower(a,b)

if ~isnumeric(b)|| length(b(:))>1
    error('In an expression a^b, b should be a scalar!');
end

c = a;
if b == 0
    c.isScalar = 1;
    c.sval = 1;
else 
    c.Z = c.Z^b;
    c.S = c.S*b;
    c.C = c.C/b;
end
