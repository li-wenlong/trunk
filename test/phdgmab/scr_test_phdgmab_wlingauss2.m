% 
% % This script invokes the constructor and init method of the
% % Multi sensor multi object simulation class msmosim
% 
% % Here, the std in angle is 2 degrees and the std in range is 3m.s
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 40;
% simcfg.deltat = ones(1,40) + ( rand(1,40) - 0.5 )*0.1;
% 
% %% Configure platform 1 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [-10 10 1 -0.1]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'lingauss'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingauss2cfg; % Get the config 
% lingausscfg.deltat = inf;
% lingausscfg.dT = 1;
% lingausscfg.psd = 0.01;
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 2 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [-10 -10 0.2 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'lingauss'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingauss2cfg; % Get the config 
% lingausscfg.deltat = inf;
% lingausscfg.dT = 1;
% lingausscfg.psd = 0.01;
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 3 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [20 0 -0.2 0.3]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'lingauss'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingauss2cfg; % Get the config 
% lingausscfg.deltat = inf;
% lingausscfg.dT = 1;
% lingausscfg.psd = 0.01;
% 
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 4 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [12 6 -0.1 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'lingauss'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingauss2cfg; % Get the config 
% lingausscfg.deltat = inf;
% lingausscfg.dT = 1;
% lingausscfg.psd = 0.01;
% 
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.
% 
% 
% 
% %% Configure platform 5 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [-7 0 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% identitycfg.deltat = inf;
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = linobscfg; % Get the config
% alpha = -pi/8;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 30;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 3;
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 6 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [11 0 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config
% identitycfg.deltat = inf;
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = linobscfg; % Get the config
% alpha = pi/8;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 50;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 3;
% 
% sensorcfg1.cluttercfg = clutcfg;
% pcfg.sensorcfgs{1} = sensorcfg1;
% 
% simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.
% % 
% sim = msmosim( simcfg );
% sim.run;
% 
% sensors = sim.getsensors;
% sensors{1}.printsr
% 
% Xt = sim.getmostates;
% plotset( Xt );
% 
% save( 'simdata_for_lingauss2_test.mat', 'sim' );
% % % 
% % % % % 
load simdata_for_lingauss2_test.mat
Xt = sim.getmostates([5,6]);
simremclut = sim;
for i=5:6
    sensor_ = simremclut.platforms{i}.sensors{1};
    %sensor_.remclutter;
    %sensor_.permz;
    simremclut.platforms{i}.sensors{1} = sensor_;
end
%simremclut.draw
%plotset( Xt, 'axis', gca,'options','''Color'',[0 0 1]')
% % 
% % % 
sensorObj1  =  sim.platforms{5}.sensors{1};
sensorObj2  =  sim.platforms{6}.sensors{1};


sensorObj1.insensorframe = 0;
sensorObj2.insensorframe = 0;


% %%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = phdgmabcfg;
filtercfg.maxnumcardbins = 20;

filtercfg.veldist = cpdf( gk( [1^2 0;0 1^2], [ 0 0]') );

modelcfg = stf_lingauss2cfg;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.psd = 0.1;
modelcfg.state = [0 0 0 0]';
     
filtercfg.targetmodelcfg = modelcfg;

initfilter = phdgmab(filtercfg);

filterObj  = initfilter;

if ~exist('isResetDefaultStream')
stream = RandStream.getGlobalStream;
reset(stream);
isResetDefaultStream = 1;
end

% 3-D Eval plot vs. scatter plot
if ~exist('displayon')
    displayon = 1;
end
if ~exist('scatterploton')
    scatterploton = 1;
    displayon = 0;
end
if scatterploton
    displayon = 0;
end
if displayon
    scatterploton= 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%

if displayon || scatterploton
    axisHandles = filterObj.getaxis('all');
end

Xhs = {};

% Use onestep
strt = 1;
numsteps = length( sensorObj1.srbuffer );
disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = strt:numsteps
    
%         Zlist = [sensorObj1.srbuffer( stepcnt ),...
%             sensorObj2.srbuffer( stepcnt )];
%         filterObj.Z = Zlist;
%         filterObj.onestep( [sensorObj1, sensorObj2] );
    
    sensorObj1.insensorframe = 0;
    Zlist = [sensorObj1.srbuffer( stepcnt )];
    filterObj.Z = Zlist;
    
    if stepcnt>=2
        dT = sensorObj1.srbuffer( stepcnt ).time - sensorObj1.srbuffer( stepcnt  -1 ).time;
        targetmodel = filterObj.targetmodel;
        targetmodel.updatemodel( dT, 0.1 );
        filterObj.targetmodel = targetmodel;
    end
    
    filterObj.onestep( [sensorObj1] );
    
    
%     sensorObj1.insensorframe = 1;
%     sensorObj2.insensorframe = 1;
%     
%     Zlist = [sensorObj1.srbuffer( stepcnt ),...
%         sensorObj2.srbuffer( stepcnt )];
%     filterObj.Z = Zlist;
%     filterObj.onestepwassoc( [sensorObj1, sensorObj2], [[2000 0 0 0]'] );
%     
    
    
    Xh = filterObj.mosest;
    Xhs = [Xhs, {Xh} ];
    
    filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-30,30,-30,30]);ylabel(''y'')','clusters','legend'); pause(0.001);
    filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-5, 5,-5,5]);ylabel(''y'')','clusters','legend'); pause(0.001);
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
    
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    drawnow;
    
    
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt-1,20)+1 == 20
        fprintf('\n');
    end
    
end

figure
plotset( Xt(strt:numsteps), 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs,'axis',gca,'options','''Color'',[1 0 0]')
title('Ground truth vs. estimated locations')

figure
plotset( Xt(strt:numsteps),'dims',[3 4]', 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs, 'dims', [3 4]', 'axis', gca, 'options', '''Color'',[1 0 0]')
title('Ground truth vs. estimated velocities')


% Below, the OSPA stuff is plotted
a = 750;
b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );

figure
subplot(311)
hold on
grid on
plot(ospacombf1,'k')
xlabel('OSPA comb.')

subplot(312)
hold on
grid on
plot(ospalocf1,'k')
xlabel('OSPA loc.')

subplot(313)
hold on
grid on
plot(ospacardf1,'k')
xlabel('OSPA card.')
