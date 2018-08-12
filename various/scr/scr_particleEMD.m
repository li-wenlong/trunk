%R1 = eye(2);
R1 = rotmat2d(-pi*45/180);
zetas = [0.25, 0.25, 0.25, 0.25];
%mus = [[-1;0], [0;1]*0.05, [0;-1]*0.05 ];
mus = [[-1;0], [0;1], [0;-1],[5;0] ];
sigmasqs = { R1*[0.05, 0;0 0.005]*R1', R1*[0.05, 0;0 0.005]*R1', R1*[0.05, 0;0 0.005]*R1',  R1*[0.05, 0;0 0.005]*R1' };
gks = gk;
for i=1:length(zetas)
gks(i) = gk( sigmasqs{i}, mus(:,i) );
end
s0 = gmm( zetas, gks );
%R2 = eye(2);
R2 = rotmat2d(pi*45/180);
zetas = [0.25, 0.25, 0.25, 0.25];
mus = [[0;1],  [0;-1], [1;0],[5.5;0]];
%mus = [[0;1]*0.05,  [0;-1]*0.05, [1;0]];
%mus = [[0;1],  [0;-1], [-1;0]];
sigmasqs = { R2*[0.05, 0;0 0.005]*R2', R2*[0.05, 0;0 0.005]*R2', R2*[0.05, 0;0 0.005]*R2',  R1*[0.05/2, 0;0 0.005/2]*R1'};
gks = gk;
for i=1:length(zetas)
gks(i) = gk( sigmasqs{i}, mus(:,i) );
end
s1 = gmm( zetas, gks );
P0 = s0.gensamples(1000);
P1 = s1.gensamples(1000);
figure;plot(P0(1,:),P0(2,:),'.');hold on;plot(P1(1,:),P1(2,:),'.r')
s0atP0 = s0.evaluate(P0);
s0atP1 = s0.evaluate(P1);
s1atP0 = s1.evaluate(P0);
s1atP1 = s1.evaluate(P1);
omega_ = 0.5;
numelP0 = length(s0atP0);
numelP1 = length(s0atP1);
denomP0 = s0atP0*numelP0/(numelP1 + numelP0) + s1atP0*numelP1/(numelP1 + numelP0);
denomP1 = s0atP1*numelP0/(numelP1 + numelP0) + s1atP1*numelP1/(numelP1 + numelP0);
% Find the estimate of z
sumP0 = sum( ( s0atP0.^(1-omega_) ).*( s1atP0.^omega_ )./( denomP0 ) );
sumP1 = sum( ( s0atP1.^(1-omega_) ).*( s1atP1.^omega_ )./( denomP1 ) );
z = ( sumP0 + sumP1 )/(numelP0 + numelP1);
zeta_omega =[  ( s0atP0.^(1-omega_) ).*( s1atP0.^omega_ )./( denomP0 ),  ( s0atP1.^(1-omega_) ).*( s1atP1.^omega_ )./( denomP1 )];
pomega = [P0,P1];
indx = resample( zeta_omega, max(numelP0, numelP1 ) );
pomegahash = pomega(:,indx);

figure(gcf)
hold on
plot( pomegahash(1,:), pomegahash(2,:), 'og')