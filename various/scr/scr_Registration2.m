

maxRange = 1000;

% Correct master sensor parameter
s0 = [-1000,-5000]';
psi0 = [90*pi/180];
% Measured master sensor parameters
s0e = [-1010,-5000]';
psi0e = [91*pi/180];


% Correct second sensor parameter
s1 = [500,-5000]';
psi1 = [10*pi/180];
% Measured master sensor parameters
s1e = [495,-4995]';
psi1e = [10.2*pi/180];

% Create an earth grid
[Xs, Ys ] = meshgrid([-maxRange:10:maxRange],[-maxRange:10:maxRange]);
X0E = [Xs(:),Ys(:)]';


% Find them in the master sensor
% Earth coordinate system projections of the grid
% i.e., the real reference points
R_BE = rotmat2d( psi0 );
los0_E =  X0E - repmat( s0, 1, size(X0E,2) );
X0B = R_BE*los0_E;

[alphas0, Rs0 ] = cart2pol( X0B(1,:), X0B(2,:) );


% Slave sensor coordinate frame representation of the grid
R_BE = rotmat2d( psi1 );
los1_E = X0E - repmat( s1, 1, size(X0E,2) ); % line of sight 1 in ECF
los1_B = R_BE*( los1_E ); % los 1 in B

% Level 1:
% The measurements on the slave sensor will be induced based on the ground
% truth:
[alphas1, Rs1] = cart2pol( los1_B(1,:), los1_B(2,:) );

% On the other hand, as the system engineer will do this conversion with
% the "faulty" parameters, the measurements above will be added considered
% biased, and, the ones below "unbiased"
% These are sensor 2 body representation of the "faulty" points

% i) The faulty conversion of the master sensor measurements
R_BE = rotmat2d( psi0e );
X0eE = R_BE'*X0B + repmat( s0e, 1, size(X0E,2) );

% ii) Faulty conversion to the slave sensor measurements

R_BE = rotmat2d( psi1e );
los1e_E = X0eE - repmat( s1e, 1, size(X0eE,2) ); % line of sight in Earth 
los1e_B = R_BE*( los1e_E );

% measurements from these points would be
[alphas1e, Rs1e ] = cart2pol( los1e_B(1,:), los1e_B(2,:) );

% The error in these points are 
X1err = los1_B - los1e_B;

% Now, the system engineer will deem the below difference as the bias of
% sensor1
theta_alpha = alphas1 - alphas1e;
theta_R = Rs1 - Rs1e;

figure
plot( los1_B(1,:), los1_B(2,:),'.b')
hold on
grid on
plot( los1e_B(1,:), los1e_B(2,:),'.r')
legend('ground truth','Assumed ground truth')

figure
subplot(211)
hold on 
grid on
plot(alphas1*180/pi,theta_alpha*180/pi,'.') 
xlabel('GT bearing (deg) ')
ylabel('Difference (deg) ')
subplot(212)
hold on 
grid on
plot(Rs1,theta_R,'.') 
xlabel('GT distance (m)')
ylabel('Difference (m)')


figure
hold on 
grid on
plot(alphas1*180/pi,Rs1,'.')
plot(alphas1e*180/pi,Rs1e,'.r') 
xlabel('bearing (deg) ')
ylabel('range (m) ')
legend('GT','assumed GT')
