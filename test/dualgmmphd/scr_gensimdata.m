% This scipt generates the simulation outputs for the measurement of a
% single target with the selected sensor network configuration.
% Called from scr_test_gaussmultigauss_selfloc_X.m
% Assumed variables:
% V, Theta, datfilename (for the latter, this script uses 'simdata_linear_singletarget4prf.mat' if
% it does not exist

numSensors = length( V );
sensorLocs = Thetas;

strtTime = 0;
stpTime = 60;
deltat = 1;

simcfg = msmosimcfg;
simcfg.tstart = strtTime;
simcfg.tstop = stpTime;
simcfg.deltat = 1;

% Configure platform 1 w/ source
deltat = 1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 500 10 0]';

pcfg.stfswitch = [0,stpTime];
pcfg.stfs = {'lingauss','die'};


% Configure the state transition function
lingausscfg = stf_lingausscfg; % Get the config 
lingausscfg.deltat = deltat;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = 0.1*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;...
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
pcfg.stfcfgs{2} = stf_diecfg; % Subs. the config
% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

% Configure the source
sourcecfg1 = sourcecfg; % Get the config
pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config

% Add targets with different initial states
InitialObjectStates = [ [0 500 10 0]',[-750 -500 0 10]',[-750 1750 10 0]',[1750,1750,0,-10]'];
for cnt = 1:size(InitialObjectStates,2);
     pcfg.state = InitialObjectStates(:,cnt);
     simcfg.platformcfgs{cnt} = pcfg; % Subs the plat cfg.
end

%% Configure sensor platforms
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state is assigned below, pulled from the array Theta
pcfg.stfswitch = [0];
pcfg.stfs = {'identity'};

% Configure the state transition function
identitycfg = stf_identitycfg; % Get the config 
pcfg.stfcfgs{1} = identitycfg; % Subs. the config

sensorcfg1 = linobscfg; % Get the config
alpha = 0;
Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
sensorcfg1.pd = 1;
sensorcfg1.maxrange = 8000;
sensorcfg1.orientation = [0 0 0];
sensorcfg1.statelabels = {'x','y'};
sensorcfg1.linTrans = [1 0;0 1];
sensorcfg1.noiseCov =   Rmat*[1 0;0 1]*Rmat'*100;

clutcfg = poisclut2cfg;
clutcfg.lambda = 5;

sensorcfg1.cluttercfg = noclutcfg;

pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config

for cnt = 1:numSensors
     pcfg.state = [sensorLocs(cnt,1),sensorLocs(cnt,2), 0 0]';
     simcfg.platformcfgs{end+1} = pcfg; % Subs the plat cfg.
end

if ~exist('datfilename')
   datfilename = 'simdata_linear_multitarget4pmrf.mat';
end
%%
sim = msmosim( simcfg );
sim.run;
[Xt, numxt] = sim.getmostates([size(InitialObjectStates,2)+1:size(InitialObjectStates,2)+numSensors]');
save( datfilename, 'sim', 'simcfg', 'Xt', 'sensorLocs' );