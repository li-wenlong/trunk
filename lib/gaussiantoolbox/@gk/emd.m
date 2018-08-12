function d = emd( a, b, w)
% d = emd( a, b, w)
% returns the covariance intersection of a and b with weight w
% d = a^(1-w)*b^(w)

d = cpdf( a^(1-w)*b^(w) );