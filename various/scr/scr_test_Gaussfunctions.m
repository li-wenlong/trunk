% This script is for testing some functions with an AR-1 Markov
% Chain for k=1,...,t 
% x_k = a x_km1 + v_k
% with v_k ~ N(.;0,sig_v), x1 ~ N(.;0,sig_x1)

sig_x1 = 0.25;
mu_x1 = 0.2;

sig_v = 0.25;
mu_v = 0;

a = 0.75; 


t = 20; % This is the length of the time window

% construct mu_x
mu_x = [mu_x1];
for i=2:t
    mu_x = [ mu_x; mu_x(end)*a + mu_v ];
end
theta_ind = 1;
x_ind = [1:t];

% Now, construct C_x in accordance with the AR1 Markov chain 
% x_1 ~ N(.;0,sig_x1 )
% x_k = a x_km1 + v_k for k=2,...,t
% with v_k ~ N(.;0,sig_v)
A = fliplr( hankel([ zeros(1,t-2) 1 -a] ) );
A = A(1:end-1,:);

C_x_inv =  transpose(A)*( eye(t-1)*(1/sig_v^2) )*A ;
C_x_inv(1) = C_x_inv(1) + 1/sig_x1^2 ;


R = chol(C_x_inv);
Rinv = R^(-1);

C_x = Rinv*Rinv';



% 1) Find the conditional distibution p(x_1,...,x5 | x_6,...,x_t)
[C_pGq, mu_pGq, a_pGq, B_pGq   ] = gausscond( C_x, [6:t], mu_x  );

% 2) Find the conditional distribution p(x_1,z_2 | x_6,...,x_t)
% a) Find p(x_1,x_2, x_6,...,x_t)
[ C_x126t ,mu_x126t ] = gaussmarg( C_x, [1,2,[6:t]], mu_x );
% b) Find p(x_1,x_2 | x_6, ..., x_t )
[C_x12G6t, mu_x12G6t, a_x12G6t, B_x12G6t ] = gausscond( C_x126t, [3:3+(t-6+1)-1] , mu_x126t);

% 3) Find the conditional distribution p( x_3 ,x_4, x_5 | x_6,...,x_t )
% a) Find p( x_3, x_4, x_5 , x_6,...,x_t )
[ C_x3t ,mu_x3t ] = gaussmarg( C_x, [3:t], mu_x );
% b) Find p(  x_3 ,x_4, x_5 | x_6,...,x_t  )
[ C_x345G6t, mu_x345G6t, a_x345G6t, B_x345G6t ] = gausscond( C_x3t , [4:4+(t-6+1)-1] , mu_x3t );

% 4) Find the (prior) marginal distribution p( x_6,...,x_t )
[ C_x6t ,mu_x6t ] = gaussmarg( C_x, [6:t], mu_x );

% 5) Find the full conditional distribution p( x_1,x_2| x_3,...,x_t)
[C_x12G, mu_x12G, a_x12G, B_x12G   ] = gausscond( C_x, [3:t], mu_x  );

% Now, Tests

% Test multocondwprior
disp('1) Testing multocondwprior following use of gaussmarg and gausscond')
% 1) Multiply  p(x_1,...,x5 | x_6,...,x_t) and p( x_6,...,x_t )
[ C_x2, mu_x2  ] = multocondwprior( C_pGq, a_pGq, B_pGq, C_x6t, mu_x6t );

err_1 = sum( sum( ( C_x - C_x2 ).^2 ) );
err_2 = sum( (mu_x - mu_x2).^2);
% Find the error
disp(sprintf('The error in covariance computation is %g ',err_1 ))
disp(sprintf('The error in mean vector computation is %g ',err_2 ))

% Test multocond, gkld and gkldcond
disp('2) Testing multocond() gkld() gkldcond() and gordervar()')
% I(x_1,x_2;x_3,x_4,x_5 | x_6:t) can be computed in two different ways

% A) I = D( p(x_1,...,x_5| x_6,...,x_t) || p(x_1,x_2 |x_6,...,x_t)p(x_3,x_4,x_5|x_6,...,x_t) ) 
% = D( p(x_1,...,x_5,x_6,...,x_t )|| p(x_1,x_2|x_6,...,x_t)p(x_3,x_4x_5| x_6,...,x_t)p(x_6,...,x_t) )
[ C_denom, a_denom, B_denom  ] = multocond( C_x12G6t, a_x12G6t, B_x12G6t , C_x345G6t, a_x345G6t, B_x345G6t );

% At this point, just a quick test for gordervar
disp('i) Testing gordervar() :')
[ C_denom2, a_denom2, B_denom2  ] = multocond( C_x345G6t, a_x345G6t, B_x345G6t,  C_x12G6t, a_x12G6t, B_x12G6t );
[C_r, mu_dummy, E ] = gordervar( C_denom2 ,[4 5 1 2 3]);

err_1 = sum(sum( (C_r-C_denom).^2 ) );
err_2 = sum(sum( (E*B_denom2 - B_denom).^2 ) );
err_3 = sum( (E*a_denom2 - a_denom).^2 ) ;
disp(sprintf('The error in covariance computation is %g ',err_1 ))
disp(sprintf('The error in mean vector computation is %g ',err_2 ))
disp(sprintf('The error in mean vector computation is %g ',err_3 ))

% Now, multiply the model in the denominator (which assumes conditional 
% independence) of the KLD with the prior
[ C_denomj, mu_denomj  ] = multocondwprior( C_denom, a_denom, B_denom, C_x6t, mu_x6t );

% Find the kld of the joints
% D( p(x_1,...,x_5,x_6,...,x_t )|| p(x_1,x_2|x_6,...,x_t)p(x_3,x_4x_5| x_6,...,x_t)p(x_6,...,x_t) )
g1 = gkld( C_x, C_denomj, mu_x, mu_denomj);

% Test the conditional gkld
disp('i) Testing multocondwprior() and gkldcond() which computes conditional KLD for Gaussians :')
% Find the conditional kld
% D( p(x_1,...,x_5| x_6,...,x_t) || p(x_1,x_2 |x_6,...,x_t)p(x_3,x_4,x_5|x_6,...,x_t) ) 
g2 = gkldcond( C_x6t, mu_x6t,  C_pGq, a_pGq, B_pGq, C_denom, a_denom, B_denom );
err_1 = abs(g1-g2);
disp(sprintf('The error in  gkldcond() with respect to gkld() with multocondwprior() is  %g ',err_1 ))

i1 = g1;

% B) I = H(x_1,x_2 |x_6,...,x_t ) - H(x_1,x_2 |x_3,x_4,x_5, x_6,...,x_t)
i2 = gentropy( C_x12G6t ) - gentropy( C_x12G );

err_1 = abs( i1 - i2 );
disp(sprintf('The error in gkldcond() computation with respect to the entropy difference method %g ',err_1 ))




