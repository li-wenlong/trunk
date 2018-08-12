% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 60;
simcfg.deltat = 1;

%% Configure platform 1 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 7500 250 0]';

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
lingausscfg.Q = ...
    [    1 0 0 0;...
         0 1 0 0;...
         0 0 1*deltat 0;...
         0 0 0 1*deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.

%% Configure platform 2 w/source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [7500 15000 0 -250]';

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
lingausscfg.Q = ...
    [    1 0 0 0;...
         0 1 0 0;...
         0 0 1*deltat 0;...
         0 0 0 1*deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg

%% Configure platform 3 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [15000 7500 -250 0]';

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
lingausscfg.Q = ...
    [    1 0 0 0;...
         0 1 0 0;...
         0 0 1*deltat 0;...
         0 0 0 1*deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.

%% Configure platform 4 w/source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [7500 0 0 250]';

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
lingausscfg.Q = ...
    [    1 0 0 0;...
         0 1 0 0;...
         0 0 1*deltat 0;...
         0 0 0 1*deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.

%% Configure platform 5 w/ sensor
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
sensorcfg1.pd = 0.95;
sensorcfg1.maxrange = 22000;
pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.

%% Configure platform 6 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [17500 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 0.95;
sensorcfg1.maxrange = 22000;
pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.

sim = msmosim( simcfg );



