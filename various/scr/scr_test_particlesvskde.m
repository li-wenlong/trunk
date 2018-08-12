% Specify two 2-D Gaussians

divby = 1;

% Gaussian 1
% mean
m1 = [-1 0]';

% Covariance matrix C1
var1 = 0.75/divby;
var2 = 0.25/divby;
R1 = rotmat2d(pi/6);
C1 = R1*[var1 0;0 var2]*R1';

% Create a Gaussian kernel object
g1 = gk( C1, m1 );

% Scale to a pdf
g1 = g1.cpdf;


% Gaussian 2
% mean
m2 = [1 0]';

% Covariance matrix C1
var1 = 0.75/divby;
var2 = 0.25/divby;
R2 = rotmat2d(-pi/6);
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

% Create a kde object from thesee particles
k1 = kde( samp1, 'rot', ones(1,sampsize)/sampsize,'g' );
k2 = kde( samp2, 'rot', ones(1,sampsize)/sampsize,'g' );                   

% Create a particles object from thesee particles
p1 = particles('states', samp1, 'weights', ones(1,sampsize)/sampsize ,'labels', 1);
p1.findkdebws;

p2 = particles('states', samp2, 'weights', ones(1,sampsize)/sampsize ,'labels', 1);
p2.findkdebws;

% Evaluate the KDE at the sample points
k1e = evaluate( k1, xy );
k2e = evaluate( k2, xy );
% Evaluate the particles at the sample points
p1e = evaluate( p1, xy);
p2e = evaluate( p2, xy);


figure
subplot(321)
surf(xx,yy, reshape(e1, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('e1')
subplot(322)
surf(xx,yy, reshape(e2, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('e2')
subplot(323)
surf(xx,yy, reshape(k1e, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('kde approx. to e1')
subplot(324)
surf(xx,yy, reshape(k2e, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('kde approx. to e2')
subplot(325)
surf(xx,yy, reshape(p1e, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('particles approx. to e1')
subplot(326)
surf(xx,yy, reshape(p2e, size(xx) ) )
axis([-2 2 -2 2 ])
shading flat
lighting phong
xlabel('x')
ylabel('y')
title('particles approx. to e2')
