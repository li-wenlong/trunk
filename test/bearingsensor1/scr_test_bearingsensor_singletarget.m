% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim

% Here, a single target is sensed by a cluster of bearings only sensors 

% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 100;
% simcfg.deltat = 1;
% 
% %% Configure platform 1 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [2000 2000 10 0]';
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
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 2 w/ sensor
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
% % Configure the sensor
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 4000;
% sensorcfg1.minrange = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 3 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [1000 4000 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 4000;
% sensorcfg1.minrange = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.
% 
% %% Configure platform 4 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [2500 2500 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 4000;
% sensorcfg1.minrange = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{4} = pcfg; % Subs the plat cfg.
% %% Configure platform 5 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [4000 500 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 4000;
% sensorcfg1.minrange = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{5} = pcfg; % Subs the plat cfg.
% %% Configure platform 6 w/ sensor
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [5000 4500 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% % Configure the sensor
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 4000;
% sensorcfg1.minrange = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.
% 
% 
% %%
% 
% 
% 
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([2,3,4,5,6]');
% save simdata_bonly_singletarget.mat sim simcfg Xt
% 
% % % Now initiate a filter and run it
% % 
load simdata_bonly_singletarget.mat
% 
% 
% simremclut = sim;
% for i=2:6
%     sensor_ = simremclut.platforms{i}.sensors{1};
%     sensor_.remclutter;
%     simremclut.platforms{i}.sensors{1} = sensor_;
% end
% simremclut.draw
% plotset( Xt, 'axis', gca,'options','''Color'',[0 0 1]')
% 
% 
sensorObj1  =  sim.platforms{2}.sensors{1};
sensorObj2  =  sim.platforms{3}.sensors{1};
sensorObj3  =  sim.platforms{4}.sensors{1};
sensorObj4  =  sim.platforms{5}.sensors{1};
sensorObj5  =  sim.platforms{6}.sensors{1};

% sensorObj1.insensorframe = 1;
% sensorObj2.insensorframe = 1;
% sensorObj3.insensorframe = 1;
% sensorObj4.insensorframe = 1;
% sensorObj5.insensorframe = 1;

% sensorObj1.remclutter; 
% sensorObj2.remclutter; 
% sensorObj3.remclutter; 
% sensorObj4.remclutter; 
% sensorObj5.remclutter; 
%%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = jottmcabcfg;
filtercfg.numpartnewborn = 250; % Number of particles for new target candidates
filtercfg.numpartpersist = 500; % Number of particles for persistent targets
filtercfg.probbirth = 0.00009;
filtercfg.probsurvive = 0.92;
filtercfg.probdetection = 0.99;

 
filtercfg.veldist = gmm(1',gk( [10^2 0;0 10^2], [ 0 0]'));

modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 0.15*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... plot( ospacombf1, 'k' )
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
initfilter = jottmcab(filtercfg);
 
filterObj  = initfilter;

if ~exist('isResetDefaultStream')
stream = RandStream.getDefaultStream;
reset(stream);
isResetDefaultStream = 1;
end

% Use onestep
numsteps = length( sensorObj1.srbuffer );

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

disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps
    
    %     Zlist = [sensorObj1.srbuffer( stepcnt ),...
    %         sensorObj2.srbuffer( stepcnt ),...
    %         sensorObj3.srbuffer( stepcnt ),...
    %         sensorObj4.srbuffer( stepcnt ),...
    %         sensorObj5.srbuffer( stepcnt )];
    %     filterObj.Z = Zlist;
    %     filterObj.onestep( [sensorObj1, sensorObj2, sensorObj3,sensorObj4,sensorObj5] );
    
        sensorObj1.insensorframe = 1;
        sensorObj2.insensorframe = 1;
        sensorObj3.insensorframe = 1;
        Zlist = [sensorObj1.srbuffer( stepcnt ),...
            sensorObj2.srbuffer( stepcnt ),...
            sensorObj3.srbuffer( stepcnt )];
        filterObj.Z = Zlist;
        filterObj.onestep( [sensorObj1, sensorObj2, sensorObj3], [[1000 4000 0 0]', [2500 2500 0 0]'] );
    
%     sensorObj1.insensorframe = 1;
%     Zlist = [sensorObj1.srbuffer( stepcnt )];
%     filterObj.Z = Zlist;
%     filterObj.onestep( [sensorObj1] );
    
    
    %     Zlist = [sensorObj1.srbuffer( stepcnt ),...
    %         sensorObj2.srbuffer( stepcnt ),...
    %         sensorObj3.srbuffer( stepcnt )];
    %     filterObj.regflag = 1;
%     filterObj.Z = Zlist;
%     filterObj.onestep( [sensorObj1, sensorObj2, sensorObj3] );
    
    Xh = filterObj.mosestodc;
    
    
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-5000,5000,-5000,5000]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-5000,5000,-5000,5000]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
   
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    Xhs = [Xhs, {Xh}];
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt-1,20)+1 == 20
        fprintf('\n');
    end

end
figure
plotset( Xt, 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs,'axis',gca,'options','''Color'',[1 0 0]')


figure
plotset( Xt,'dims',[3 4]', 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs, 'dims',[3 4]', 'axis',gca,'options','''Color'',[1 0 0]')  

a = 500;
b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );

figure
subplot(311)
grid on
hold on
plot( ospalocf1, 'k' )
ylabel('OSPA loc.')
subplot(312)
grid on
hold on
plot( ospacardf1, 'k' )
ylabel('OSPA card.')
subplot(313)
grid on
hold on
plot( ospacombf1, 'k' )
ylabel('OSPA comb.')




numdets = sensorObj1.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );








