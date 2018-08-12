function p = permcoeff( n, j)
% function p = permcoeff( n, j)
% returns the permutation coefficient P for j-permutations of n-elements.
% p = 0 for n<j or either n or j is zero.
% Murat Uney

if n<j
    p = 0;
    return;
end
if n==j && n~=0
    p = prod([n-j + 1:n]);
    
elseif n==j && n==0
    p = 1;
else
    p = prod([n-j+1:n]); %factorial(n)/factorial(n-j);
end