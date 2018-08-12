% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% Here, the std in angle is 2 degrees and the std in range is 3m.s
deltat = 1;

simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 120;
simcfg.deltat = deltat; %deltat %1;

%% Configure platform 1 w/ source
%;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-4000 4000 106.666666666667  -106.666666666667]'/2;

pcfg.stfswitch = [10, 85];
pcfg.stfs = {'lingauss','die'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat; %0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 5*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.

%% Configure platform 2 w/ source
%;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [1.333333333333334e+03 6.866666666666669e+03 0 -1.366666666666667e+02]'/2;

pcfg.stfswitch = [0,70];
pcfg.stfs = {'lingauss','die'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat; %0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 5*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;
% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.

%% Configure platform 3 w/ source
%;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-4000 5000 120 -40]'/2;

pcfg.stfswitch = [35,110];
pcfg.stfs = {'lingauss','die'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat; %0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 5*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;
% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.

%% Configure platform 4 w/ source
%;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-6.135294117647059e+03 2.594117647058823e+03 1.376470588235294e+02 12.941176470588236]'/2;

pcfg.stfswitch = [25,95];
pcfg.stfs = {'lingauss','die'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat; %0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 5*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;
% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.

%% Configure platform 5 w/ source
%;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [4000 4000 -106.666666666667  -106.666666666667  ]'/2;

pcfg.stfswitch = [50,120];
pcfg.stfs = {'lingauss','die'};

% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat; %0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 5*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;
% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.


%% Configure platform 6 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-2000 -8000 0 0]'/2;

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
pcfg.stfcfgs{1} = identitycfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg;
% Configure the sensor
sensorcfg1 = rbsensor2cfg; % Get the config
sensorcfg1.pd = 0.95;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 15;
sensorcfg1.maxrange = 16000;
sensorcfg1.alpha = 70*pi/180;
sensorcfg1.orientation = [pi/2 0 0];

clutcfg = poisclut2cfg;
clutcfg.lambda = 10;

% clutcfg = noclutcfg;


sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.

%% Configure platform 7 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [2000 -8000 0 0]'/2;

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor2cfg; % Get the config
sensorcfg1.pd = 0.95;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 15;
sensorcfg1.maxrange = 16000;
sensorcfg1.alpha = 70*pi/180;
sensorcfg1.orientation = [pi/2 0 0];

clutcfg = poisclut2cfg;
clutcfg.lambda = 10;

% clutcfg = noclutcfg;

sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{7} = pcfg; % Subs the plat cfg.

%% Configure platform 8 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [6000 -6000 0 0]'/2;

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor2cfg; % Get the config
sensorcfg1.pd = 0.95;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 15; % 5;
sensorcfg1.maxrange = 16000;
sensorcfg1.alpha = 70*pi/180;
sensorcfg1.orientation = [pi/2+pi/4, 0, 0];

clutcfg = poisclut2cfg;
clutcfg.lambda = 10;

% clutcfg = noclutcfg;

sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{8} = pcfg; % Subs the plat cfg.
% 
sim = msmosim( simcfg );

sim.run;
[Xt, numxt] = sim.getmostates([6,7,8]');
% save('simdata_5t3s_pd095_c.mat','sim','simcfg','Xt')

