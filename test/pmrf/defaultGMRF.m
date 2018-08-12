sigmasq_x_1 = 2;
sigmasq_x_2 = 2;
sigmasq_x_3 = 2;
sigmasq_x_4 = 2;

rho_A = 0.25;
rho_B = 0.25;
rho_C = 0.25;

% Compute the corresponding marginal standard variations
sigma_x_1 = sqrt( sigmasq_x_1 );
sigma_x_2 = sqrt( sigmasq_x_2 );
sigma_x_3 = sqrt( sigmasq_x_3 );
sigma_x_4 = sqrt( sigmasq_x_4 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% First compute the covariance matrix for the joint distribution, i.e.
%%% C_x_1234 and its information form Lambda_x_1234 = C_x_1234^(-1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lambda_x_1G3 = [ 1/(sigmasq_x_1*(1-rho_A^2) ), -rho_A/(sigma_x_1*sigma_x_3*(1-rho_A^2) ); ...
    -rho_A/(sigma_x_1*sigma_x_3*(1-rho_A^2) ), rho_A^2/(sigmasq_x_3*(1-rho_A^2))];
Lambda_x_2G3 = [ 1/(sigmasq_x_2*(1-rho_B^2) ), -rho_B/(sigma_x_2*sigma_x_3*(1-rho_B^2) ); ...
    -rho_B/(sigma_x_2*sigma_x_3*(1-rho_B^2) ), rho_B^2/(sigmasq_x_3*(1-rho_B^2))];
Lambda_x_3G4 = [ 1/(sigmasq_x_3*(1-rho_C^2) ), -rho_C/(sigma_x_3*sigma_x_4*(1-rho_C^2) ); ...
    -rho_C/(sigma_x_3*sigma_x_4*(1-rho_C^2) ), rho_C^2/(sigmasq_x_4*(1-rho_C^2))];
Lambda_x_4 = [ 1/sigmasq_x_4 ];

Lambda_x_1234 = [ Lambda_x_1G3(1,1), 0, Lambda_x_1G3(1,2), 0; 0 0 0 0; Lambda_x_1G3(2,1) 0 Lambda_x_1G3(2,2) 0;0 0 0 0]+...
[0 0 0 0; 0 Lambda_x_2G3(1,1), Lambda_x_2G3(1,2),0 ; 0, Lambda_x_2G3(2,1), Lambda_x_2G3(2,2), 0; 0 0 0 0]+...
[0 0 0 0;0 0 0 0; 0 0 Lambda_x_3G4(1,1) Lambda_x_3G4(1,2);0 0 Lambda_x_3G4(2,1) Lambda_x_3G4(2,2)]+...
[0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 Lambda_x_4(1,1)];

C_x_1234 = Lambda_x_1234^(-1);
% Since x = {x_1, x_2, x_3, x_4 } reassign the covariance matrix and its
% information form to variables named accordingly.
C_x = C_x_1234;
Lambda_x = Lambda_x_1234;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Second, compute the covariance matrices for marginal distributions and
%%% express them as symbolic expressions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below the marginal variances are found out, i.e.
% p(x_1),...,p(x_4),p(x_1,x_2,x_3), p( x_3, x_4)
% Also p(x_1,x_2), p( x_1, x_3 ) and p(x2, x_3)
% Lambda_x_1 = Lambda_x(1,1) - Lambda_x(1,2:end)*Lambda_x(2:end,2:end)^(-1)*Lambda_x(2:end,1); 
% Lambda_x_1 = 1/sigmasq_x_1
E = eye(4);
S = E*Lambda_x*E';
Lambda_x_1 = S(1,1) - S(1, [2:4])*S([2:4], [2:4])^(-1)*S([2:4],1);
sigmasq_x_1 = 1/Lambda_x_1;
% Lambda_x_2 = 1/sigmasq_x_2
E = eye(4);
E = E([2 1 3 4],:);
S = E*Lambda_x*E';
Lambda_x_2 = S(1,1) - S(1, [2:4])*S([2:4], [2:4])^(-1)*S([2:4],1);
sigmasq_x_2 = 1/Lambda_x_2;
% Lambda_x_3 = 1/sigmasq_x_3
E = eye(4);
E = E([3 2 1 4],:);
S = E*Lambda_x*E';
Lambda_x_3 = S(1,1) - S(1, [2:4])*S([2:4], [2:4])^(-1)*S([2:4],1);
sigmasq_x_3 = 1/Lambda_x_3;
% Lambda_x_4 = 1/sigmasq_x_4
E = eye(4);
E = E([4 2 3 1],:);
S = E*Lambda_x*E';
Lambda_x_4 = S(1,1) - S(1, [2:4])*S([2:4], [2:4])^(-1)*S([2:4],1);
sigmasq_x_4  = 1/Lambda_x_4;
% Lambda_x_34
E = eye(4);
E = E([3 4 1 2],:);
S = E*Lambda_x*E';
Lambda_x_34 = S([1 2],[1 2]) - S([1 2],[3 4])*S([3 4],[3 4])^(-1)*S([3 4],[1 2]);
C_x_34 = Lambda_x_34^(-1);
% Lambda_x_13
E = eye(4);
E = E([1 3 2 4],:);
S = E*Lambda_x*E';
Lambda_x_13 = S([1 2],[1 2]) - S([1 2],[3 4])*S([3 4],[3 4])^(-1)*S([3 4],[1 2]);
C_x_13 = Lambda_x_13^(-1);
% Lambda_x_23
E = eye(4);
E = E([2 3 1 4],:);
S = E*Lambda_x*E';
Lambda_x_23 = S([1 2],[1 2]) - S([1 2],[3 4])*S([3 4],[3 4])^(-1)*S([3 4],[1 2]);
C_x_23 = Lambda_x_23^(-1);
%Lambda_x_12
E = eye(4);
E = E([1 2 3 4],:);
S = E*Lambda_x*E';
Lambda_x_12 = S([1 2],[1 2]) - S([1 2],[3 4])*S([3 4],[3 4])^(-1)*S([3 4],[1 2]);
C_x_12 = Lambda_x_12^(-1);

% Lambda_x_123
Lambda_x_123 = Lambda_x([1 2 3],[1 2 3]) - Lambda_x([1 2 3],4)*Lambda_x(4,4)^(-1)*Lambda_x(4,[1 2 3]);
C_x_123 = Lambda_x_123^(-1);

mu_x_1 = 0;
mu_x_2 = 0;
mu_x_3 = 0;
mu_x_4 = 0;
mu_x_34 = [mu_x_3 mu_x_4]';
mu_x_12 = [mu_x_1 mu_x_2]';
mu_x_13 = [mu_x_1 mu_x_3]';
mu_x_23 = [mu_x_2 mu_x_3]';
mu_x_123 = [mu_x_1 mu_x_2 mu_x_3]';
mu_x_1234 =  [mu_x_1 mu_x_2 mu_x_3 mu_x_4]';
% % Below the symbolic expressions are built to double check the consistency
% % of the marginals and the conditionals
% syms p_x_1 p_x_2 p_x_3 p_x_4 p_x_123 p_x_34 p_x_13 p_x_23 x_1 x_2 x_3 x_4
% p_x_1 = (1/(sqrt(2*pi*sigmasq_x_1)) )*exp( -0.5*(x_1 - mu_x_1)^2/sigmasq_x_1);
% p_x_2 = (1/(sqrt(2*pi*sigmasq_x_2)) )*exp( -0.5*(x_2 - mu_x_2)^2/sigmasq_x_2);
% p_x_3 = (1/(sqrt(2*pi*sigmasq_x_3)) )*exp( -0.5*(x_3 - mu_x_3)^2/sigmasq_x_3);
% p_x_4 = (1/(sqrt(2*pi*sigmasq_x_4)) )*exp( -0.5*(x_4 - mu_x_4)^2/sigmasq_x_4);
% 
% p_x_34 = (1/(2*pi*sqrt(det(C_x_34 ))) )*exp( -0.5*transpose([[x_3;x_4]-mu_x_34])*inv(C_x_34 )*[[x_3;x_4]-mu_x_34] );
% p_x_12 = (1/(2*pi*sqrt(det(C_x_12 ))) )*exp( -0.5*transpose([[x_1;x_2]-mu_x_12])*inv(C_x_12 )*[[x_1;x_2]-mu_x_12] );
% p_x_13 = (1/(2*pi*sqrt(det(C_x_13 ))) )*exp( -0.5*transpose([[x_1;x_3]-mu_x_13])*inv(C_x_13 )*[[x_1;x_3]-mu_x_13] );
% p_x_23 = (1/(2*pi*sqrt(det(C_x_23 ))) )*exp( -0.5*transpose([[x_2;x_3]-mu_x_23])*inv(C_x_23 )*[[x_2;x_3]-mu_x_23] );
% 
% p_x_123 =(1/( (2*pi)^(3/2)*sqrt(det(C_x_123 ))) )*exp( -0.5*transpose([[x_1;x_2;x_3]-mu_x_123])*inv(C_x_123 )*[[x_1;x_2;x_3]-mu_x_123] );

% Below the conditionals are found out, i.e. p( x_1, x_2 | x_3 ),       
% p( x_2, x_3 | x_1 ), p( x_3, x_1 | x_2), p(x_3 | x_4), p(x_4 | x_3)
% Note that the mean of these distributions are determined by the given
% variable' s value according to the following exp. in the information form
% of a Gaussian distribution p(x_1|x_2); v_1g2 = v_1 - Lambda_12*x_2 

% Find p(x_3 | x_4)
%syms v_3g4 mu_x_3g4 x_3 x_4 p_x_3g4;
%v_3g4 = -Lambda_x_34(1,2)*x_4;
Lambda_3g4 = Lambda_x_34(1,1);

C_x_3g4 = Lambda_3g4^(-1);
%mu_x_3g4 = C_x_3g4*v_3g4;
%p_x_3g4 = (1/(sqrt(2*pi*C_x_3g4)))*exp( -(1/2)*( x_3 - mu_x_3g4)^2/C_x_3g4);

% Find p(x_4 | x_3)
E = eye(2);
E = E([2 1],:);
S = E*C_x_34*E';
Lambda_S = S^(-1);

%syms v_4g3 mu_x_4g3 x_3 p_x_4g3;
%v_4g3 = -Lambda_S(1,2)*x_3;
Lambda_4g3 = Lambda_S(1,1);

C_x_4g3 = Lambda_4g3^(-1);
%mu_x_4g3 = C_x_4g3*v_4g3;
%p_x_4g3 = (1/(sqrt(2*pi*C_x_4g3)))*exp( -(1/2)*( x_4 - mu_x_4g3)^2/C_x_4g3);

% Find  p( x_1, x_2 | x_3 )
%syms v_x_12g3 mu_x_12g3 x_1 x_2 x_3 p_x_12g3;
%v_x_12g3 = -Lambda_x_123([1 2],[3])*x_3;
C_x_12g3 = Lambda_x_123([1 2],[1 2])^(-1);

%mu_x_12g3 = C_x_12g3*v_x_12g3;
%p_x_12g3 = (1/(2*pi*sqrt(det(C_x_12g3)) ) )*exp( -(1/2)*( transpose( [ [x_1;x_2] - mu_x_12g3])*inv(C_x_12g3)*[ [x_1;x_2]-mu_x_12g3]) );

% Find p( x_2, x_3 | x_1 )
E = eye(3);
E = E([2,3,1],:);
S = E*C_x_123*E';
Lambda_S = S^(-1);

%syms v_x_23g1 mu_x_23g1 p_x_23g1;
%v_x_23g1 = -Lambda_S([1 2],[3])*x_1;
C_x_23g1 = Lambda_S([1 2],[1 2])^(-1);

%mu_x_23g1 = C_x_23g1*v_x_23g1;
%p_x_23g1 = (1/(2*pi*sqrt(det(C_x_23g1)) ) )*exp( -(1/2)*( transpose( [ [x_2;x_3] - mu_x_23g1])*inv(C_x_23g1)*[ [x_2;x_3]-mu_x_23g1]) );

% Find p( x_3, x_1 | x_2)
E = eye(3);
E = E([3,1,2],:);
S = E*C_x_123*E';
Lambda_S = S^(-1);

%syms v_x_31g2 mu_x_31g2 p_x_31g2;
%v_x_31g2 = -Lambda_S([1 2],[3])*x_2;
C_x_31g2 = Lambda_S([1 2],[1 2])^(-1);

%mu_x_31g2 = C_x_31g2*v_x_31g2;
%p_x_31g2 = (1/(2*pi*sqrt(det(C_x_31g2)) ) )*exp( -(1/2)*( transpose( [ [x_3;x_1] - mu_x_31g2])*inv(C_x_31g2)*[ [x_3;x_1]-mu_x_31g2]) );



disp('The marginal distributions for x_1,..., x_4 are gaussian with zero mean and variances')
disp(sprintf(' %f \n %f \n %f \n %f\n respectively',sigmasq_x_1, sigmasq_x_2, sigmasq_x_3, sigmasq_x_4 ))
