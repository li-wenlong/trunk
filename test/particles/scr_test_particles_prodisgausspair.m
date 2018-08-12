% Specify two 2-D Gaussians

divf = 32;
% Gaussian 1
% mean
m1 = [-1 0]';

% Covariance matrix C1
var1 = 0.75/divf;
var2 = 0.25/divf;
R1 = rotmat2d(0*pi/6);
C1 = R1*[var1 0;0 var2]*R1';

% Create a Gaussian kernel object
g1 = gk( C1, m1 );

% Scale to a pdf
g1 = g1.cpdf;


% Gaussian 2
% mean
m2 = [1 0]';

% Covariance matrix C1
var1 = 0.75/divf;
var2 = 0.25/divf;
R2 = rotmat2d(-pi/6*0);
C2 = R2*[var1 0;0 var2]*R2';

% Create a Gaussian kernel object
g2 = gk( C2, m2 );

% Scale to a pdf
g2 = g2.cpdf;

deltas = 0.01;
deltass = sqrt(deltas);
[xx,yy] = meshgrid([-2:deltass:2],[-2:deltass:2] );
xy = [xx(:), yy(:)]';

% Find the product density
e1 = g1.evaluate( xy );
e2 = g2.evaluate( xy );

pd = e1.*e2;
Z = sum(pd*deltas);
pd = pd/Z;

% Now, use the sampler to find the product density
% Select a sample size
sampsize = 1000;

% Generate samples from the Gaussian pdf
samp1 = g1.gensamples(sampsize);
samp2 = g2.gensamples(sampsize);

% Create a particles object from thesee particles
p1 = particles('states', samp1, 'weights', ones(1,sampsize)/sampsize ,'labels', 1);
p1.findkdebws;

p2 = particles('states', samp2, 'weights', ones(1,sampsize)/sampsize ,'labels', 1);
p2.findkdebws;

% k2 = kde( samp2, 'rot', ones(1,sampsize)/sampsize,'g' );

par(1) = p1;
par(2) = p2;

pp = prodisgausspair( par );
% Evaluate the KDE at the sample points
zz1 = pp.evaluate( xy, 'threshold', -1000 );
% Evaluate the Gaussian at the sample points


figure
set(gcf,'Color',[1 1 1])
subplot(221)
surf(xx,yy, reshape(e1, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('e1')
subplot(222)
surf(xx,yy, reshape(e2, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('e2')
subplot(223)
surf(xx,yy, reshape(pd, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('e1*e2')

subplot(224)
surf(xx,yy, reshape(zz1, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('product() approx. to e1*e2')

pdist = cpdf( g1*g2);
ppts = pdist.gensamples(sampsize);
ppts2 = pp.sample( sampsize );

figure
hold on 
grid on
plot( ppts(1,:), ppts(2,:),'.')
plot( ppts2(1,:), ppts2(2,:),'.r')
legend('ProdGauss','ProdSample')


