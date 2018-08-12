% Specify a 2-D Gaussian

% mean
m1 = [-1 -1]';

% Covariance matrix C1
var1 = 0.75;
var2 = 0.25;
R1 = rotmat2d(pi/6);
C1 = R1*[var1 0;0 var2]*R1';

% Create a Gaussian kernel object
g1 = gk( C1, m1 );

% Scale to a pdf
g1 = g1.cpdf;

% Select a sample size
sampsize = 20000;

% Generate samples from the Gaussian pdf
samp1 = g1.gensamples(sampsize);

% Create a particles object from thesee particles
p1 = particles('states', samp1, 'weights', ones(1,sampsize)/sampsize ,'labels', 1);
p1.subblabels( ones(1,sampsize) );
p1.blmap(2) = 2;
p1.blabels = [p1.blabels;p1.blabels];

% Find the KDE BWs
p1.updatekdebwsblabh('nonsparse');

% Evaluate the KDE at the sample points
zz1 = p1.evaluate( samp1, 'threshold', -10 );
% Evaluate the Gaussian at the sample points
zz1a = g1.evaluate( samp1 );

% Visual inspection:
figure
hold on 
grid on
plot3( samp1(1,:), samp1(2,:), zz1 , '.b')
plot3( samp1(1,:), samp1(2,:), zz1a , '.r')
legend('KDE','Gaussian')
view(-10,50)
xlabel('x')
ylabel('y')


