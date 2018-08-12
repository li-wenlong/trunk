function sums = sumesf(numbers)

m = length(numbers);
if m==0
    sums = 1;
else

    result = [1; -numbers(1)];
    for idx=2:m
        result = conv([1; -numbers(idx)],result);
    end

    flip = [2:2:m+1]';
    sign = ones(m+1,1); 
    sign(flip) = -1*ones(size(flip));
    sums = sign.*result;
end