function K = getkalmangains(this, H,R)

numcomps = this.getnumcomp;

for i=1:numcomps
    P = this.pdfs(i).get('C');
    
    M = H*P*H';
    M = M + R(1:size(M,1), 1:size(M,2));
    
    T = chol( M )';
    
    iT = inv(T);
    
    
    K(:,:,i) = P*H'*(iT'*iT);
end
