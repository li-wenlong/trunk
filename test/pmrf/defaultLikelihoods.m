
% Determine the 
sigmasq_n1 = 0.5;
mu_n1 = 0;
sigmasq_n2 = 0.5;
mu_n2 = 0;
sigmasq_n3 = 0.5;
mu_n3 = 0;
sigmasq_n4 = 0.5;
mu_n4 = 0;
% Calculate the parameters for p(y_1), p(y_2), p(y_3), p(y_4)
sigmasq_y1 = sigmasq_x_1 + sigmasq_n1;
mu_y1 = 0 + mu_n1;
sigmasq_y2 = sigmasq_x_2 + sigmasq_n2;
mu_y2 = 0 + mu_n2;
sigmasq_y3 = sigmasq_x_3 + sigmasq_n3;
mu_y3 = 0 + mu_n3;
sigmasq_y4 = sigmasq_x_4 + sigmasq_n4;
mu_y4 = 0 + mu_n4;

% Construct the symbolic expressions for marginal observation densities
% syms y_1 y_2 y_3 y_4 
% p_y_1 = (1/(sqrt(2*pi*sigmasq_y1)) )*exp( -0.5*(y_1 - mu_y1)^2/sigmasq_y1);
% p_y_2 = (1/(sqrt(2*pi*sigmasq_y2)) )*exp( -0.5*(y_2 - mu_y2)^2/sigmasq_y2);
% p_y_3 = (1/(sqrt(2*pi*sigmasq_y3)) )*exp( -0.5*(y_3 - mu_y3)^2/sigmasq_y3);
% p_y_4 = (1/(sqrt(2*pi*sigmasq_y4)) )*exp( -0.5*(y_4 - mu_y4)^2/sigmasq_y4);
% 
% p_y_1Gx_1 = (1/(sqrt(2*pi*sigmasq_n1)) )*exp( -0.5*(y_1 - x_1 - mu_n1)^2/sigmasq_n1);
% p_y_2Gx_2 = (1/(sqrt(2*pi*sigmasq_n2)) )*exp( -0.5*(y_2 - x_2 - mu_n2)^2/sigmasq_n2);
% p_y_3Gx_3 = (1/(sqrt(2*pi*sigmasq_n3)) )*exp( -0.5*(y_3 - x_3 - mu_n3)^2/sigmasq_n3);
% p_y_4Gx_4 = (1/(sqrt(2*pi*sigmasq_n4)) )*exp( -0.5*(y_4 - x_4 - mu_n4)^2/sigmasq_n4);

disp('The marginal distributions for observation processes y_1,..., y_4 are gaussian with zero mean and variances')
disp(sprintf(' %f \n %f \n %f \n %f\n respectively',sigmasq_y1, sigmasq_y2, sigmasq_y3, sigmasq_y4 ))