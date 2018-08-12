function p = permcoeff( n, j)

if n<j
    p = 0;
    return;
end

p = factorial(n)/factorial(n-j);
    