% % % This script invokes the constructor and init method of the
% % % Multi sensor multi object simulation class msmosim
% % 
% % % Here, a single target is sensed by a cluster of linear sensors 
% 
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 100;
% simcfg.deltat = 1;
% 
% % Configure platform 1 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [0 500 10 0]';
% 
% pcfg.stfswitch = [0,100];
% pcfg.stfs = {'lingauss','die'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingausscfg; % Get the config 
% lingausscfg.deltat = 1;
% lingausscfg.F = ...
%    [1 0 1*deltat 0;...
%     0 1 0 1*deltat;...
%     0 0 1 0;...
%     0 0 0 1];
% lingausscfg.Q = 0.1*[...
%         deltat^3/3 0 deltat^2/2 0;...
%         0 deltat^3/3 0 deltat^2/2;... about:startpage
%         deltat^2/2 0 deltat 0;...
%          0 deltat^2/2 0 deltat];
% 
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% pcfg.stfcfgs{2} = stf_diecfg; % Subs. the config
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.
% 
% % Configure platform 2 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [500 0 0 10]';
% 
% pcfg.stfswitch = [0,100];
% pcfg.stfs = {'lingauss','die'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingausscfg; % Get the config 
% lingausscfg.deltat = 1;
% lingausscfg.F = ...
%    [1 0 1*deltat 0;...
%     0 1 0 1*deltat;...
%     0 0 1 0;...
%     0 0 0 1];
% lingausscfg.Q = 0.1*[...
%         deltat^3/3 0 deltat^2/2 0;...
%         0 deltat^3/3 0 deltat^2/2;... about:startpage
%         deltat^2/2 0 deltat 0;...
%          0 deltat^2/2 0 deltat];
% 
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% pcfg.stfcfgs{2} = stf_diecfg; % Subs. the config
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.
% 
% % Configure platform 3 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [1000 100 -10 0]';
% 
% pcfg.stfswitch = [0,100];
% pcfg.stfs = {'lingauss','die'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingausscfg; % Get the config 
% lingausscfg.deltat = 1;
% lingausscfg.F = ...
%    [1 0 1*deltat 0;...
%     0 1 0 1*deltat;...
%     0 0 1 0;...
%     0 0 0 1];
% lingausscfg.Q = 0.1*[...
%         deltat^3/3 0 deltat^2/2 0;...
%         0 deltat^3/3 0 deltat^2/2;... about:startpage
%         deltat^2/2 0 deltat 0;...
%          0 deltat^2/2 0 deltat];
% 
% pcfg.stfcfgs{1} = lingausscfg; % Subs. the config
% pcfg.stfcfgs{2} = stf_diecfg; % Subs. the config
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 4 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [0 0 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% sensorcfg1 = linobscfg; % Get the config
% alpha = pi/8;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 3000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 3;
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 5 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [1000 0 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = linobscfg; % Get the config
% alpha = -pi/8;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 3000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 3;
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.
% %%
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([4,5]');
% save simdata_linear_multitarget1.mat sim simcfg Xt

% % % % % % Now initiate a filter and run it
% % % % % 
load simdata_linear_multitarget1.mat

simremclut = sim;
for i=4:5
    sensor_ = simremclut.platforms{i}.sensors{1};
    sensor_.remclutter;
    simremclut.platforms{i}.sensors{1} = sensor_;
end
%simremclut.draw
%plotset( Xt, 'axis', gca,'options','''Color'',[0 0 1]')
% % 
% % % 
sensorObj1  =  sim.platforms{4}.sensors{1};
sensorObj2  =  sim.platforms{5}.sensors{1};


sensorObj1.insensorframe = 0;
sensorObj2.insensorframe = 0;


sensorObj1.remclutter; 
sensorObj2.remclutter;

sensorObj1.permz;
sensorObj2.permz;

% %%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = kfcfg;
filtercfg.veldist = cpdf( gk( [15^2 0;0 15^2], [ 0 0]') );
% filtercfg.initstate = cpdf( gk( diag( [15^2, 15^2, 15^2, 15^2] ) , [0 500 10 0]' ) );


modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 2.0*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... plot( ospacombf1, 'k' )
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;

initfilter = kf(filtercfg);

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
    
        Zlist = [sensorObj1.srbuffer( stepcnt ),...
            sensorObj2.srbuffer( stepcnt )];
        filterObj.Z = Zlist;
        filterObj.onestepwassoc( [sensorObj1, sensorObj2] );
    
    % sensorObj1.insensorframe = 0;
    % Zlist = [sensorObj1.srbuffer( stepcnt )];
    % filterObj.Z = Zlist;
    % filterObj.onestepwassoc( [sensorObj1] );
    
    
%     sensorObj1.insensorframe = 1;
%     sensorObj2.insensorframe = 1;
%     
%     Zlist = [sensorObj1.srbuffer( stepcnt ),...
%         sensorObj2.srbuffer( stepcnt )];
%     filterObj.Z = Zlist;
%     filterObj.onestepwassoc( [sensorObj1, sensorObj2], [[2000 0 0 0]'] );
%     
    
    
    Xh_entry = [];
    for ocnt = 1:length( filterObj.post )
        Xh = filterObj.post(ocnt).m;
        
        
        Xh_entry(:,ocnt) = Xh;
        
    end
    filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-1000,1000,-1000,1000]);ylabel(''y'')','clusters','legend'); pause(0.001);
    filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
    
    plotset( Xh_entry, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh_entry, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    
    Xhs = [Xhs, {Xh_entry} ];
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt-1,20)+1 == 20
        fprintf('\n');
    end
    
end

figure
plotset( Xt(strt:numsteps), 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs,'axis',gca,'options','''Color'',[1 0 0]')

figure
plotset( Xt(strt:numsteps),'dims',[3 4]', 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs, 'dims', [3 4]', 'axis', gca, 'options', '''Color'',[1 0 0]')


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
