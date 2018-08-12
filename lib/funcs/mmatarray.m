function A = mmatarray( A, M )
% B = mmatarray( A, M ) multiplies the matrices stored in A with M. In
% particular, A is axbxc storing c many axb matrices and M is bxd. The
% result B is axdxc storing c many results.

[a, b, c] = size(A);
[d, e ] = size(M);

% b and d should be equal
if b~=d
    error('The number of col.s of A and the rows of M do not match!');
end
A = reshape( (reshape(A, [a, b*c])'*M' )', [a,d,c] ); 

    

