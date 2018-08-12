% % % % This script invokes the constructor and init method of the
% % % % Multi sensor multi object simulation class msmosim
% % % 
% % % 
% % Here a single range-bearing intensity map sensor is used
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 30;
% simcfg.deltat = 1;
% 
% %% Configure platform 1 w/ source
% deltat = simcfg.deltat;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [ -3000*sin(15*pi/180), 3000*cos(15*pi/180), 20, -10]';
% 
% pcfg.stfswitch = [0,30];
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
% lingausscfg.Q = 0.01*[...
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
% %% Configure platform 2 w/ rbintmap1 sensor
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
% sensorcfg1 = rbintmap1cfg; % Get the config
% sensorcfg1.minrange = 2000;
% sensorcfg1.maxrange = 3500;
% sensorcfg1.minalpha = -20*pi/180;
% sensorcfg1.maxalpha = 20*pi/180;
% sensorcfg1.signalpower = 1.0;
% sensorcfg1.betasquare = 0.25;
% 
% senorientation = sensorcfg1.orientation;
% senorientation(1) = pi/2;
% 
% sensorcfg1.orientation = senorientation;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{2} = pcfg; % Subs the plat cfg.
% 
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([2]');
% 
% save rbintmap_testdata6db.mat sim simcfg Xt

% % % % Now initiate a filter and run it
% % % 
load rbintmap_testdata6db.mat

sensorObj = sim.platforms{2}.sensors{1};
sensorObj.signalpower = 1.0;
sensorObj.betasquare = 0.25;
% % remove the comment outs for the lines below to test the methods npart and
% % likelihood without filtering
% nbpars = sensorObj.nbpart(sensorObj.srbuffer(1),4);
% G = sensorObj.likelihood( sensorObj.srbuffer(1), nbpars );
% for i=1:size( nbpars, 2)   
%     w(i) = exp( log(G(1,i)) -log(G(2,i)) ); % This is the \Omega(z_c(x)|x)
% end
% figure;
% plot3( nbpars(1,:),nbpars(2,:),w,'.')


% %%%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = berintmap1cfg;
filtercfg.numpartnewborn = 225; % Number of particles per pixel for testing new born targets
filtercfg.numpartpersist = 10000; % Number of particles for persistent targets
filtercfg.probbirth = 0.01; % target per pixel per 100 steps
filtercfg.probsurvive = 0.99;
filtercfg.regflag = 0;
%  
velstd = 0.01;
gk1 = gk( [velstd^2 0;0 (velstd*2.2)^2], [ 20 -10]');
%filtercfg.veldist = gmm([1 ]',[gk1]);
% velstd = 4;
% gk1 = gk( [(velstd)^2 0;0 (velstd*8)^2], [ 20 0]');
% gk2 = gk( [velstd^2 0;0 (velstd*8)^2], [ -20 0]');
% gk3 = gk( [(velstd*8)^2 0;0 velstd^2], [0 20]');
% gk4 = gk( [(velstd*8)^2 0;0 velstd^2], [0 -20]');
% gk5 = gk( [(15)^2 0;0 (15)^2], [0 0]');
% 
% filtercfg.veldist = gmm([0.2 0.2 0.2 0.2 0.2]',[gk1, gk2, gk3, gk4, gk5]);
% %filtercfg.veldist = gmm([0.25 0.25 0.25 0.25]',[gk1, gk2, gk3, gk4]);      
% % 
modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
if filtercfg.regflag
    qfactor = 0.05;
else
    qfactor = 0.05;
end
 modelcfg.Q = qfactor*[...
     deltat^3/3 0 deltat^2/2 0;...
     0 deltat^3/3 0 deltat^2/2;...
     deltat^2/2 0 deltat 0;...
     0 deltat^2/2 0 deltat];
filtercfg.targetmodelcfg = modelcfg;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
% Initialise
berfilter = berintmap1(filtercfg); % cphd particle birth with detected process cardinality
initberfilter = berfilter;   % initial filt

filterObj  = initberfilter;

 
% Use onestep
numsteps = length( sensorObj.srbuffer );


axisHandles = filterObj.getaxis('all');
%%%%
measfhandle = figure;
set(measfhandle, 'color', [1 1 1]);
set( measfhandle, 'doublebuffer', 'on' );

measaxis = gca;
hold on
grid on
set( measaxis, 'XtickMode', 'auto' )
set( measaxis, 'FontSize', 14 )

trackfhandle = figure;
set( trackfhandle, 'color', [1 1 1]);
set( trackfhandle, 'doublebuffer', 'on' );

traxis = gca;
hold on
grid on
set( traxis, 'XtickMode', 'auto' )
set( traxis, 'FontSize', 14 )

%%%%

Xhs = {};
disp(sprintf('Filtering the buffer of length %d :', numsteps));
zoom_mult = 2;
% 
loglhoods = [];
sploglhoods = [];
for stepcnt = 1:numsteps 
       
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    loglhoods = [loglhoods, filterObj.parloglhood ];
    sploglhoods = [ sploglhoods, filterObj.sploglhood];
    
    if ~isempty( filterObj.postintensity )
        [Xh,Cs,dummy, clmass ]= filterObj.mosestodc('threshold',0.5 );
    else
        [Xh,Cs,dummy, clmass ]= filterObj.mosestodc;
    end  
    Xhs{stepcnt} = Xh;
    
    filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-1500,1500,1500,4000]);ylabel(''y'')','clusters','legend'); pause(0.001);
    filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-40,40,-40,40]);ylabel(''y'')','clusters','legend'); pause(0.001);
    
        
    plotset( Xt{stepcnt}, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2','shift',9 );
    plotset( Xt{stepcnt}, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Marker'',''x'',''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2' ,'shift', 9);
   
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    drawnow;
    
     
    cla(measaxis)
    sensorObj.draw('axis',measaxis,'timestep', stepcnt);
    colorbar
    drawnow
    % Draw the posterior particles
    cla(traxis)
    filterObj.postintensity.s.particles.draw('axis',traxis);
    plotset( Xhs(1:stepcnt),'axis',gca,'options','''Color'',[1 0 0],''linewidth'',3','shift',10)
    plotset( Xt(1:stepcnt), 'axis', gca, 'options','''Color'',[0 0 0],''linewidth'',2,''LineStyle'',''none'',''Marker'',''x''','shift',9);
    axis([-1000 1000 2250 3250])
    drawnow
   
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt-1,20)+1 == 20
        fprintf('\n');
    end

end
% 
figure
plotset( Xhs,'axis',gca,'options','''Color'',[0 0 0],''linewidth'',3')
plotset( Xt, 'axis', gca, 'options','''Color'',[0 1 1],''LineStyle'',''none'',''Marker'',''x''');
title('Target trajectory and location estimates')

figure
plotset( Xt,'dims',[3 4]', 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs, 'dims',[3 4]', 'axis',gca,'options','''Color'',[1 0 0]')  
title('Target velocity and estimates')

a = 200;
b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );
% a = max(ospalocf1);
% b = 1;
% [ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );


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





