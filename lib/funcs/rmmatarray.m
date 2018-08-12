function A = rmmatarray( A, M )
% B = rmmatarray( A, M ) right multiplies M with the matrices stored in A. 
% In particular, A is axbxc storing c many axb matrices and M is bxd. The
% result B is axdxc storing c many results.
% e.g. B(:,:,1) = A(:,:,1)*M;
%

[a, b, c] = size(A);
[d, e ] = size(M);

% b and d should be equal
if b~=d
    error('The number of col.s of A and the rows of M do not match!');
end

A = permute(A, [2,1,3]);
A = lmmatarray( A, M' );
A = permute(A, [2,1,3]);

    

