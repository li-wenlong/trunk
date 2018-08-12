function  [ C_f, a_f, B_f  ] = multocond( C_0, a_0, B_0, C_1, a_1, B_1 )
% MULTOCOND returns the parameters for the product Gaussian in the
% following multiplication
% N(z; a_z + B_zy; C_y) = N(x0; a0 + B0y, C0 )N(x1; a1 + B1y, C1 )
% where z = [x0;x1]

% First, find the covariance matrices 

R = chol(C_0);
Rinv = R^(-1);

Lambda_0 = Rinv*Rinv';


R = chol(C_1);
Rinv = R^(-1);

Lambda_1 = Rinv*Rinv';

Lambda_f = blkdiag( Lambda_0, Lambda_1 );

R = chol(Lambda_f);
Rinv = R^(-1);

C_f = Rinv*Rinv';
% Done!

% Second, find the linear transform parameterising the mean vector
a_f = [a_0; a_1];
B_f = [B_0; B_1];





    
    