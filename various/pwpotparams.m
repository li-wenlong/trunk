function [varargout] = pwpotparams( varargin )

sigmasq_x_1 = 1;
sigmasq_x_2 = 1;

rho_A = 0.75;
% Compute the corresponding marginal standard variations
sigma_x_1 = sqrt( sigmasq_x_1 );
sigma_x_2 = sqrt( sigmasq_x_2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lambda_x_1G2 = [ 1/(sigmasq_x_1*(1-rho_A^2) ), -rho_A/(sigma_x_1*sigma_x_2*(1-rho_A^2) ); ...
    -rho_A/(sigma_x_1*sigma_x_2*(1-rho_A^2) ), rho_A^2/(sigmasq_x_2*(1-rho_A^2))];

Lambda_x_12 = [ 1/(sigmasq_x_1*(1-rho_A^2) ), -rho_A/(sigma_x_1*sigma_x_2*(1-rho_A^2) ); ...
    -rho_A/(sigma_x_1*sigma_x_2*(1-rho_A^2) ), 1/(sigmasq_x_2*(1-rho_A^2))];

params.jointdist = cpdf( gk( Lambda_x_12^(-1),[0,0]' ) );
params.localmarg = cpdf( gk( gaussmarg( Lambda_x_12^(-1), 1 ), 0 ) );
params.neimarg =  cpdf( gk( gaussmarg( Lambda_x_12^(-1), 1 ), 0 ) );

varargout{1} = params;