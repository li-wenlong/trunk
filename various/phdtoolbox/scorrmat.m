function Cs = scorrmat(E,C)
% SCORRMAT Sparsified Correlation Matrix
% Can not produce a positive definite matrix yet!!!

% Find the cholesky factorization such that C = R'*R
R = chol(C);
Rinv = R^(-1);
Cinv = Rinv*Rinv';
Cs = diag(diag(Cinv));

for i=1:size(E,1)
   Cs(E(i,1),E(i,2) ) = Cinv(E(i,1),E(i,2));
   Cs(E(i,2),E(i,1) ) = Cs(E(i,1),E(i,2) );
end
D  = Cinv-Cs;
N = size(Cs,1);
for i=1:N
  %  scaleFactor = sum(abs(Cinv(i,:)))/sum(abs(Cs(i,:)));
  %  Cs(i,:) = Cs(i,:)*scaleFactor;
    scaleFactor = Cs(i,i)/sum( ( Cs(i,[[1:i-1],[i+1:N]]) ));
    Cs(i,[[1:i-1],[i+1:N]]) = Cs(i,[[1:i-1],[i+1:N]])*scaleFactor;
    
    if ~isempty( find(eig(Cs)<0) )
        i
    end
    Cs([[1:i-1],[i+1:N]],i) = Cs([[1:i-1],[i+1:N]],i)*scaleFactor;
end
Cs = (Cs+Cs')/2;



R = chol(Cs);
Rinv = R^(-1);
Cs = Rinv*Rinv';

