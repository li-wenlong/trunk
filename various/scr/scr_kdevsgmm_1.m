% This script is to test how the kde evaluates distributions
% and observe the pros and cons of whitening the particle set

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test the evaluation of single gaussians in 2-D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%R1 = eye(2);
R1 = rotmat2d(-pi*45/180);

num_samples = 10000;
C0 =  R1*[0.05, 0;0 0.005]*R1';
m0 = [0.25 0.25]';

%s0 = gmm( [0.5,0.5], gks([1,2] ) );
s0 = gmm( 1, gk( C0, m0 ) );
P0 = s0.gensamples(num_samples);

s0_kde  = kde( P0, 'rot',ones(1,num_samples)/num_samples ,'Gauss' );


[X,Y] = meshgrid([-1:0.01:1],[-1:0.01:1]);

xs = [X(:),Y(:)];

zs0_gmm = evaluate(s0, xs');
zs0_kde = evaluate( s0_kde, xs' );


zp0_gmm = evaluate(s0, P0 );
zp0_kde = evaluate( s0_kde, P0 );


figure
surf(X,Y,reshape(zs0_gmm, size(X,1), size(X,2)))
xlabel('x')
ylabel('y')
colorbar

figure
surf(X,Y,reshape(zs0_kde, size(X,1), size(X,2)))
xlabel('x')
ylabel('y')
colorbar




disp(sprintf('Average MSE over the square region %g',sum( (zs0_gmm - zs0_kde ).^2 )/length(zs0_gmm) ))
disp(sprintf('Average MSE over the particles %g',sum( (zp0_gmm - zp0_kde ).^2 )/length(zp0_gmm) ))

%%% The second kde after a whitening transform
C_p = cov( P0');
% Get the mean
m_ = mean( P0' );
% Find the inverse covariance
R = chol(C_p);
Rinv = R^(-1);
Lambda_p = Rinv*Rinv';
Wp = sqrtm(Lambda_p);% The whitening trasform

% KDE after the wightening transform:
s0_kde_2 = kde( Wp*P0, 'rot',ones(1,num_samples)/num_samples ,'Gauss'  ); % Weights are scaled at constructor
zs0_kde_2 = (1/sqrt( det( C_p ) )) * evaluate( s0_kde_2, Wp*(xs') );
zp0_kde_2 = (1/sqrt( det( C_p ) )) * evaluate( s0_kde_2, Wp*(P0 ) );

figure
surf(X,Y,reshape(zs0_kde_2, size(X,1), size(X,2)))
xlabel('x')
ylabel('y')
colorbar
disp(sprintf('Weightened particles: Average MSE over the square region %g',sum( (zs0_gmm - zs0_kde_2 ).^2 )/length(zs0_gmm) ))
disp(sprintf('Weightened particles: Average MSE over the particles %g',sum( (zp0_gmm - zp0_kde_2 ).^2 )/length(zp0_gmm) ))