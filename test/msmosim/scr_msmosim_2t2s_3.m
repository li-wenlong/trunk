% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% This is the first of two crossing tracks

% Here, the std in angle is 2 degrees and the std in range is 3m.s
simcfg = msmosimcfg;
simcfg.tstart = 0;
simcfg.tstop = 110;
simcfg.deltat = 1;

%% Configure platform 1 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-4000 -5000 120 40]';
pcfg.stfswitch = [35,110];
% will be  on [1333.3333 , -1333.3333]  on 60 sec. (50 sec. after birth)
pcfg.stfs = {'lingauss','die'};

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

%% Configure platform 2 w/ source
deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-6.135294117647059e+03 -2.594117647058823e+03 1.376470588235294e+02 -12.941176470588236]';

pcfg.stfswitch = [25,95];
pcfg.stfs = {'lingauss','die'};

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

simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.


%% Configure platform 3 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [-2000 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 0.90;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 5;
sensorcfg1.maxrange = 8000;
sensorcfg1.orientation = [0 0 0];

clutcfg = poisclut1cfg;
clutcfg.lambda = 5;

% clutcfg = noclutcfg;


sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.


%% Configure platform 4 w/ sensor
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [2000 0 0 0]';

pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

% Configure the sensor
sensorcfg1 = rbsensor1cfg; % Get the config
sensorcfg1.pd = 0.90;
sensorcfg1.stdang = 2*pi/180;
sensorcfg1.stdrange = 5;
sensorcfg1.maxrange = 8000;
sensorcfg1.orientation = [0 0 0];

clutcfg = poisclut1cfg;
clutcfg.lambda = 5;

% clutcfg = noclutcfg;

sensorcfg1.cluttercfg = clutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.
%
sim = msmosim( simcfg );

sim.run
sim.draw


% figure
% for i=1:85
%     cla;
%     
% sim.show('axis',gca,...
%     'time',i,...
%     'trackplotoptions',...
%     {'''Linewidth'',3,''Markersize'',6,''Marker'',''s'',''Color'',[0.5, 1, 1]',...
%     '''Linewidth'',3,''Markersize'',6,''Marker'',''s'',''Color'',[1, 0.5, 0.5]',...
%     '''Linewidth'',6,''Markersize'',8,''Marker'',''o'',''Color'',[1, 0, 0]',...
%     '''Linewidth'',6,''Markersize'',8,''Marker'',''o'',''Color'',[0, 1, 1]'},...
%     'obsplotoptions',...
%     {{''},{''},...
%     {'''Linewidth'',2.5,''MarkerSize'',12,''Marker'',''x'',''Color'',[1, 0, 0]'},...
%     {'''Linewidth'',2.5,''MarkerSize'',12,''Marker'',''x'',''Color'',[0, 1, 1]'} },...
%     'postcommands','axis([-9000,9000,-9000,9000])'...
%     );
% pause(0.1);
% end
