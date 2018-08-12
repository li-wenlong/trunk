% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% For an example where
% the std in angle is 2 degrees and the std in range is 3m.s
% And no clutter

simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 50;
simcfg.deltat = 1;

%% Configure platform 1 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 530.3301 10.6066 -10.6066]';

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
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 1;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 3/10;
sensorcfg1.maxrange = 7500/10;
sensorcfg1.orientation = [0 0 0];

clutcfg = poisclut1cfg;
clutcfg.lambda = 5;

% clutcfg = noclutcfg;


sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.

% 
sim = msmosim( simcfg );



