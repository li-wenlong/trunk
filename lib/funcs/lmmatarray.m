function A = lmmatarray( A, M )
% B = lmmatarray( A, M ) left multiplies M with the matrices stored in A. 
% In particular, A is axbxc storing c many axb matrices and M is dxa. The
% result B is axdxc storing c many results.
% e.g. B(:,:,1) = M*A(:,:,1);
%

[a, b, c] = size(A);
[d, e ] = size(M);

% b and d should be equal
if a ~= e
    error('The number of rows.s of A and the cols of M do not match!');
end
A = reshape( (reshape(A, [a, b*c])'*M' )', [d,b,c] ); 

    

