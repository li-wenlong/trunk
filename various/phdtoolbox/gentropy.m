function d = gentropy( C_p  )
% GENTROPY is the entropy of a multi-variate Gaussian and it is a function
% of only the covariance matrix.
% d = 


k = size(C_p,1);
d = k/2*(1+log(2*pi)) + 1/2*log( det(C_p) );