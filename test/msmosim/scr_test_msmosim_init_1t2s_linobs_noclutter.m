% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% This setting presents that 
% The Linear Transformation and the Noise Covariance are in the sensor
% coordinate system, i.e., y[n] = linTrans*x[n] + sqrt(noiseCov)*randn
% refers to x, and hence y in the sensor coordinate system. Therefore two
% sensors with different orientations would have different uncertainties
% along the same axis.

simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 40;
simcfg.deltat = 1;

%% Configure platform 1 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-3535.53390593274 3535.53390593274 176.776695296637 -176.776695296637]';

pcfg.stfswitch = [0];
pcfg.stfs = {'lingauss'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = 0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 0*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.

%% Configure platform 2 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
identitycfg.F = zeros( length(pcfg.state) );
identitycfg.Q = zeros( length(pcfg.state) );
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = linobscfg; % Get the config
alpha = pi/4;
Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
sensorcfg1.pd = 1;
sensorcfg1.maxrange = 4500;
sensorcfg1.orientation = [0 0 0];
sensorcfg1.statelabels = {'x','y'};
sensorcfg1.linTrans = [1 0;0 1];
sensorcfg1.noiseCov = Rmat*[0.8 0;0 0.2]*Rmat'*22000/100;

%clutcfg = poisclut1cfg;
%clutcfg.lambda = 5;

clutcfg = noclutcfg;


sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.

%% Configure platform 3 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
identitycfg.F = zeros( length(pcfg.state) );
identitycfg.Q = zeros( length(pcfg.state) );

pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = linobscfg; % Get the config
alpha = -pi/4;
Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
sensorcfg1.pd = 1;
sensorcfg1.maxrange = 4500;
sensorcfg1.orientation = [0 0 0];
sensorcfg1.statelabels = {'x','y'};
sensorcfg1.linTrans = [1 0;0 1];
sensorcfg1.noiseCov =   Rmat*[0.8 0;0 0.2]*Rmat'*22000/100;

%clutcfg = poisclut1cfg;
%clutcfg.lambda = 5;

clutcfg = noclutcfg;

sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.
% 
sim = msmosim( simcfg );



