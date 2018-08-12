function Cx = wcov( P, w )

[N,M] = size(P);

w = w(:)/sum(w);


mx = sum( P.*repmat(w', N , 1) , 2);

dP = ( P - repmat( mx, 1, M ) ).*repmat( sqrt(w' ), N, 1);

Cx = (1/(1 - sum(w.^2) ) )* (dP*dP');