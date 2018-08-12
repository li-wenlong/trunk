% This script is to test the translate and rotate method of @particles,
% i.e., @particles.transrot

% rot angle
alpha_ = 45*pi/180;

% rot center
rcntr =  [1,-2]';


% Initialize particles

numparticles = 4000;


R1 = rotmat2d(0/180);
zetas = [0.25, 0.25, 0.25, 0.25];
%mus = [[-1;0], [0;1]*0.05, [0;-1]*0.05 ];
mus = [[-1;0], [0;1], [0;-1],[1;0] ];
sigmasqs = { R1*[0.1, 0;0 0.05]*R1', R1*[0.1, 0;0 0.05]*R1', ...
    R1*[0.05, 0;0 0.1]*R1',  R1*[0.05, 0;0 0.1]*R1' };
gks = gk;
for i=1:length(zetas)
gks(i) = gk( sigmasqs{i}, mus(:,i) );
end
s0 = gmm( zetas, gks );
[P0, labels] = s0.gensamples(numparticles);

p = particles( 'states', P0, 'labels', labels, 'weights', 1/numparticles );

p.updatekdebws('nonsparse');


[XX, YY] = meshgrid([-5:0.05:5], [-5:0.05:5]);

pnts = [XX(:),YY(:)]';
z1 = p.evaluate(pnts);


p2 = p.transrot('translate', rcntr , 'alpha', alpha_, 'centre', rcntr );
z2 = p2.evaluate(pnts);


figure
subplot(221)
axis equal
mesh( XX, YY, reshape(z1, size(XX) ));
xlabel('x')
view(0,90)
title('Initial')


subplot(222)
axis equal
mesh( XX, YY, reshape(z2, size(XX) ));
xlabel('x')
view(0,90)
title('Translation + rotation')

subplot(223)
axis equal
grid on
hold on
contour( XX, YY, reshape(z1, size(XX) ));
xlabel('x')
view(0,90)
title('Initial')

subplot(224)
axis equal
grid on
hold on
contour( XX, YY, reshape(z2, size(XX) ));
xlabel('x')
view(0,90)
title('Translation + rotation')
