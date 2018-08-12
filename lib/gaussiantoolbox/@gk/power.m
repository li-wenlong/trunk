function c = power(a,b)

if ~isnumeric(b)
    error('In an expression a.^b, b should be a numeric array!');
end
if prod(size(a))~=1
    if prod(size(b)) == 1
        b = ones(size(a))*b;
    else
        if sum(abs(size(a)-size(b)))~=0
        error('In an expression a.^b, if a is not 1x1, both arrays should be of same size or b should be 1x1!');
        end
    end
    c = a;
else
    c = repmat(a, size(b));
end

for i=1:length(b(:))
    c(i) = c(i)^b(i);
end