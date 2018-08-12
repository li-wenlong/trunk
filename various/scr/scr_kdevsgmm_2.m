% This script is to test how the kde evaluates distributions

%R1 = eye(2);
R1 = rotmat2d(-pi*45/180);
zetas = [0.25, 0.25, 0.25, 0.25];
%mus = [[-1;0], [0;1]*0.05, [0;-1]*0.05 ];
mus = [[-0.5;0], [0;0.5], [0;-0.5],[0.5;0] ];
sigmasqs = { R1*[0.05, 0;0 0.005]*R1', R1*[0.05, 0;0 0.005]*R1', R1*[0.05, 0;0 0.005]*R1',  R1*[0.05, 0;0 0.005]*R1' };
gks = gk;
for i=1:length(zetas)
    gks(i) = gk( sigmasqs{i}, mus(:,i) );
    scomps(i) = gmm( 1, gks(i) );
end

s0 = gmm( zetas, gks );

num_samples = 10000;
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
shading flat
xlabel('x')
ylabel('y')
colorbar
title('GMM')

figure
surf(X,Y,reshape(zs0_kde, size(X,1), size(X,2)))
shading flat
xlabel('x')
ylabel('y')
colorbar
title('KDE')




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
s0_kde_2 = kde( Wp*(P0), 'rot',ones(1,num_samples)/num_samples ,'Gauss'  ); % Weights are scaled at constructor
zs0_kde_2 = (1/sqrt( det( C_p ) )) * evaluate( s0_kde_2, Wp*(xs') );
zp0_kde_2 = (1/sqrt( det( C_p ) )) * evaluate( s0_kde_2, Wp*(P0 ) );

figure
surf(X,Y,reshape(zs0_kde_2, size(X,1), size(X,2)))
xlabel('x')
ylabel('y')
lighting phong
shading flat
colorbar
title('KDE 2')

disp(sprintf('Whitened particles: Average MSE over the square region %g',sum( (zs0_gmm - zs0_kde_2 ).^2 )/length(zs0_gmm) ))
disp(sprintf('Whitened particles: Average MSE over the particles %g',sum( (zp0_gmm - zp0_kde_2 ).^2 )/length(zp0_gmm) ))