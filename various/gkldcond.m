function  d = gkldcond( C_y, mu_y,  C_0, a_0, B_0, C_1, a_1, B_1)

Bd = (B_0 - B_1 );
ad = a_0 - a_1;
SigmaT = Bd*C_y*Bd' + ( ad + Bd*mu_y )*( ad + Bd*mu_y )'; 



R = chol(C_1);
Rinv = R^(-1);

Lambda_1 = Rinv*Rinv';
Lambda_1 = inv(C_1);
n = size(C_1, 1 );

d = 0.5*log( det(C_1)/det(C_0) ) + 0.5*trace( Lambda_1*C_0 ) - n/2 ...
    + 0.5*trace( Lambda_1*SigmaT );