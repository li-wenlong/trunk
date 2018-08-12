% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% Here, the std in angle is 2 degrees and the std in range is 3m.s
simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 20;
simcfg.deltat = ones(1,20) + ( rand(1,20) - 0.5 )*0.1;

%% Configure platform 1 w/ source
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-10 10 1 -0.1]';

pcfg.stfswitch = [0];
pcfg.stfs = {'lingauss'};

% Configure the state transition function
lingausscfg = stf_lingauss2cfg; % Get the config 
lingausscfg.deltat = inf;
lingausscfg.dT = 1;
lingausscfg.psd = 0.01;
pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.

%% Configure platform 2 w/ source
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-10 -10 0.2 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'lingauss'};

% Configure the state transition function
lingausscfg = stf_lingauss2cfg; % Get the config 
lingausscfg.deltat = inf;
lingausscfg.dT = 1;
lingausscfg.psd = 0.01;
pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.

%% Configure platform 3 w/ source
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [20 0 -0.2 0.3]';

pcfg.stfswitch = [0];
pcfg.stfs = {'lingauss'};

% Configure the state transition function
lingausscfg = stf_lingauss2cfg; % Get the config 
lingausscfg.deltat = inf;
lingausscfg.dT = 1;
lingausscfg.psd = 0.01;

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.

%% Configure platform 4 w/ source
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [12 6 -0.1 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'lingauss'};

% Configure the state transition function
lingausscfg = stf_lingauss2cfg; % Get the config 
lingausscfg.deltat = inf;
lingausscfg.dT = 1;
lingausscfg.psd = 0.01;

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.



%% Configure platform 5 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-7 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
identitycfg.deltat = inf;
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 0.90;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 3;
sensorcfg1.maxrange = 7500;
sensorcfg1.orientation = [0 0 0];

clutcfg = poisclut1cfg;
clutcfg.lambda = 5;

% clutcfg = noclutcfg;


sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.

%% Configure platform 6 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [11 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config
identitycfg.deltat = inf;
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 0.90;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 3;
sensorcfg1.maxrange = 7500;
sensorcfg1.orientation = [0 0 0];

clutcfg = poisclut1cfg;
clutcfg.lambda = 5;

% clutcfg = noclutcfg;

sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.
% 
sim = msmosim( simcfg );
sim.run;

sensors = sim.getsensors;
sensors{1}.printsr

Xt = sim.getmostates;
plotset( Xt );

save( 'simdata_for_lingauss2_test.mat', 'sim' );





