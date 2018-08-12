function  [ C_joint, mu_joint  ] = multocondwprior( C_x, a, B, C_y, mu_y )
% MULTOCONDWPRIO returns the parameters for the product Gaussian
% following multiplication of a conditional density with a prior
% N( [x;y]; mu_xy ; C_xy ) = N(x; a + By, C_x )N(y; mu_y, C_y )


N = size(C_x,2);
M = size(C_y,2);
% First, find the information matrices 
R = chol(C_x);
Rinv = R^(-1);

Lambda_0 = Rinv*Rinv';


R = chol(C_y);
Rinv = R^(-1);

Lambda_1 = Rinv*Rinv';

Lambda_f = blkdiag( Lambda_0, Lambda_1 );



T = [ eye(N), -B; zeros(M,N), eye(M) ];

Lambda_joint = T'*Lambda_f*T;


R = chol(Lambda_joint);
Rinv = R^(-1);

C_joint = Rinv*Rinv';

mu_joint = inv(T)*[a;mu_y];   