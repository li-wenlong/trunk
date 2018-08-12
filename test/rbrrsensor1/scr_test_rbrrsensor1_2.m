% % This script invokes the constructor and init method of the
% % Multi sensor multi object simulation class msmosim
% 
% % This is the first of two crossing tracks
% 
% % Here, the std in angle is 2 degrees and the std in range is 3m.s
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 40;
% simcfg.deltat = 1;
% 
% 
% %% Configure platform 1 w/ source
% deltat = 0.1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [0 2000 0 -25]';
% 
% pcfg.stfswitch = [0,40];
% pcfg.stfs = {'lingauss','die'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingausscfg; % Get the config 
% lingausscfg.deltat = 0.1;
% lingausscfg.F = ...
%    [1 0 1*deltat 0;...
%     0 1 0 1*deltat;...
%     0 0 1 0;...
%     0 0 0 1];
% lingausscfg.Q = 0*[...
%         deltat^3/3 0 deltat^2/2 0;...
%         0 deltat^3/3 0 deltat^2/2;... 
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
% 
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
% sensorcfg1 = rbrrsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 2*pi/180;
% sensorcfg1.stdrange = 10; % 25;
% sensorcfg1.stdrangerate = 1;
% sensorcfg1.maxrange = 5000;
% sensorcfg1.maxvel = 50;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.0001;
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
% sensorcfg1 = rbsensor2cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 2*pi/180;
% sensorcfg1.stdrange = 10; % 25;
% sensorcfg1.maxrange = 5000;
% sensorcfg1.alpha = pi;
% sensorcfg1.orientation = [pi/2 0 0];
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.0001;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{3} = pcfg; % Subs the plat cfg.
% 
% % 
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([2, 3]');
% save rbrrsensortestdata_1t2s_2.mat sim simcfg Xt

% % Now initiate a filter and run it

load rbrrsensortestdata_1t2s_2.mat
sensorObj  =  sim.platforms{3}.sensors{1};
sensorObj2  =  sim.platforms{2}.sensors{1};

deltat = 1;
filtercfg = cphdmcabcfg;
filtercfg.numpartnewborn = 400; % Number of particles for new target candidates
filtercfg.numpartpersist = 2000; % Number of particles for persistent targets
filtercfg.probbirth = 0.0009;
filtercfg.probsurvive = 0.98;
filtercfg.probdetection = 0.95;

filtercfg.veldist = gmm(1',gk( [15^2 0;0 15^2], [ 0 0]'));

modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 0*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... plot( ospacombf1, 'k' )
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
initcphdfilter = cphdmcab(filtercfg);


filterObj  = initcphdfilter;
filterObj2  = initcphdfilter;

if ~exist('isResetDefaultStream')
stream = RandStream.getDefaultStream;
reset(stream);
isResetDefaultStream = 1;
end

% Use onestep
numsteps = length( sensorObj.srbuffer );

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
%%%%%%%%%%%%%%%%%%%%%%%%%%

if displayon || scatterploton
    axisHandles = filterObj.getaxis('all');
end

if displayon || scatterploton
    axisHandles2 = filterObj2.getaxis('all');
end

Xhs = {};
Xhs2 = {};

disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps 
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    Xh = filterObj.mosestodc;
    
    filterObj2.Z = sensorObj2.srbuffer( stepcnt );
    filterObj2.onestep( sensorObj2 );
    Xh2 = filterObj2.mosestodc;
    
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-2250,2250,-2250,2250]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-2250,2250,-2250,2250]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
   
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    if displayon
        filterObj2.displaybuffers('axis',axisHandles2([1,3,4,6]),'precommands','cla;','postcommands','axis([-2250,2250,-2250,2250]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj2.displaybuffers('axis',[axisHandles2(2),0,axisHandles2(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj2.scplotbuffers('axis',axisHandles2([1,3,4,6]),'precommands','cla;','postcommands','axis([-2250,2250,-2250,2250]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj2.scplotbuffers('axis',[axisHandles2(2),0,axisHandles2(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles2(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles2(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
   
    plotset( Xh2, 'dims', [1 2],'axis', axisHandles2(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh2, 'dims', [3 4],'axis', axisHandles2(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    
    Xhs = [Xhs, {Xh}];
    Xhs2 = [Xhs2, {Xh2}];
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt,20)==0
        fprintf('\n');
    end

end

a = 500;
b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );
[ospacombf2, ospalocf2, ospacardf2] = calcOSPAseries( Xt, Xhs2, a, b ); 

figure
subplot(311)
grid on
hold on
plot( ospalocf1, 'k' )
plot( ospalocf2, 'b' )
ylabel('OSPA loc.')
subplot(312)
grid on
hold on
plot( ospacardf1, 'k' )
plot( ospacardf2, 'b' )
ylabel('OSPA card.')
subplot(313)
grid on
hold on
plot( ospacombf1, 'k' )
plot( ospacombf2, 'b' )
ylabel('OSPA comb.')

  

numdets = sensorObj.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );










