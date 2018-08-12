% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim


% % Here, Bearings only sensors are used 
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 60;
% simcfg.deltat = 1;
% 
% %% Configure platform 1 w/ source
% deltat = simcfg.deltat;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [-300 1500 10 20]';
% 
% pcfg.stfswitch = [0,60];
% pcfg.stfs = {'lingauss','die'};
% 
% % Configure the state transition function
% lingausscfg = stf_lingausscfg; % Get the config 
% lingausscfg.deltat = deltat;
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
% pcfg.stfcfgs{2} = stf_diecfg;
% 
% % Configure the source
% sourcecfg1 = sourcecfg; % Get the config
% pcfg.sourcecfgs{1} = sourcecfg1; % Subs, the config
% 
% simcfg.platformcfgs{1} = pcfg; % Subs the plat cfg.
% 
% 
% %% Configure platform 2 w/ eosensor
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
% sensorcfg1 = eosensorcfg; % Get the config
% pdprofilecfg = sensorcfg1.pdprofilecfg;
% pdprofilecfg.pdatzero = 1.0;
% pdprofilecfg.pdfar = 0.9;
% pdprofilecfg.range = 10000;
% pdprofilecfg.threshold = 4000;
% sensorcfg1.pdprofilecfg = pdprofilecfg;
% 
% sensorcfg1.F = 0.012;
% sensorcfg1.S2 = 0.012;
% sensorcfg1.numrows = 768;
% sensorcfg1.numcols = 2962;
% 
% senorientation = sensorcfg1.orientation;
% senorientation(1) = pi/2;
% sensorcfg1.orientation = senorientation;
% % sensorcfg1.detonlynear = 1;
% 
% clutcfg = eobinomclutcfg;
% clutcfg.p = 10/( sensorcfg1.numrows * sensorcfg1.numcols);
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.
% 
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([2]');
% 
% save eosensortestdata1.mat sim simcfg Xt

% % % Now initiate a filter and run it
% % 
load eosensortestdata1.mat
sensorObj  =  sim.platforms{2}.sensors{1};

 
% %%%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = phdcdecfg;
filtercfg.maxnumcardbins = 1200;
filtercfg.numpartnewborn = 400; % Number of particles for new target candidates
filtercfg.numpartpersist = 1500; % Number of particles for persistent targets
filtercfg.probbirth = 0.003;
filtercfg.probsurvive = 0.97;
filtercfg.probdetection = 0.9999;
filtercfg.regflag = 1;
%  
% velstd = 18/3;
% gk1 = gk( [velstd^2 0;0 (velstd*2.2)^2], [ 25 0]');
% gk2 = gk( [velstd^2 0;0 (velstd*2.2)^2], [ -25 0]');
% gk3 = gk( [(velstd*2.2)^2 0;0 velstd^2], [0 25]');
% gk4 = gk( [(velstd*2.2)^2 0;0 velstd^2], [0 -25]');
% gk5 = gk( [(0.2)^2 0;0 (0.2)^2], [0 0]');
% 
% filtercfg.veldist = gmm([0.2 0.2 0.2 0.2 0.2]',[gk1, gk2, gk3, gk4, gk5]);
velstd = 1;
gk1 = gk( [(velstd)^2 0;0 (velstd*8)^2], [ 25 0]');
gk2 = gk( [velstd^2 0;0 (velstd*8)^2], [ -25 0]');
gk3 = gk( [(velstd*8)^2 0;0 velstd^2], [0 25]');
gk4 = gk( [(velstd*8)^2 0;0 velstd^2], [0 -25]');
gk5 = gk( [(0.025)^2 0;0 (0.025)^2], [0 0]');

filtercfg.veldist = gmm([0.2 0.2 0.2 0.2 0.2]',[gk1, gk2, gk3, gk4, gk5]);
%filtercfg.veldist = gmm([0.25 0.25 0.25 0.25]',[gk1, gk2, gk3, gk4]);      
% 
modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
if filtercfg.regflag
    qfactor = 0.25;
else
    qfactor = 1;
end
 modelcfg.Q = qfactor*[...
     deltat^3/3 0 deltat^2/2 0;...
     0 deltat^3/3 0 deltat^2/2;...
     deltat^2/2 0 deltat 0;...
     0 deltat^2/2 0 deltat];
% modelcfg.Q = 15*[...
%     deltat^3/3 0 deltat^2/2 0;...
%     0 deltat^3/3 0 deltat^2/2;...
%     deltat^2/2 0 deltat 0;...
%     0 deltat^2/2 0 deltat];
filtercfg.targetmodelcfg = modelcfg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
% Initialise
phdfilter = phdcde(filtercfg); % cphd particle birth with detected process cardinality
initphdfilter = phdfilter;   % initial filt

filterObj  = initphdfilter;

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
%%%%%%%%%%%%%%%%%%%%%%%%%

if displayon || scatterploton
    axisHandles = filterObj.getaxis('all');
end

fhandle = figure;
Xhs = {};
disp(sprintf('Filtering the buffer of length %d :', numsteps));
zoom_mult = 2;

for stepcnt = 1:numsteps 
       
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    
    if ~isempty( filterObj.postintensity )
        [Xh,Cs,dummy, clmass ]= filterObj.mosestodc('threshold',1/filterObj.postintensity.mu/5);
    else
        [Xh,Cs,dummy, clmass ]= filterObj.mosestodc;
    end
    
    Xhs{stepcnt} = Xh;
    
    if scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-1000,1000,0,5000]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-50,50,-50,50]);ylabel(''y'')','clusters','legend'); pause(0.001);
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
plotset( Xhs,'axis',gca,'options','''Color'',[0 0 0],''linewidth'',3')
plotset( Xt, 'axis', gca, 'options','''Color'',[0 1 1],''LineStyle'',''none'',''Marker'',''x''');


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





