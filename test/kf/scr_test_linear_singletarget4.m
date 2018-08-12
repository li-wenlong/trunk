% % This script invokes the constructor and init method of the
% % Multi sensor multi object simulation class msmosim
% 
% % Here, a single target is sensed by a cluster of linear sensors 

% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 200;
% simcfg.deltat = 1;
% 
% % Configure platform 1 w/ source
% deltat = 1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [0 500 10 0]';
% 
% pcfg.stfswitch = [0,200];
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
% sensorcfg1 = linobscfg; % Get the config
% alpha = pi/8;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 8000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
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
% pcfg.state = [2000 0 0 0]';
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
% sensorcfg1.maxrange = 8000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
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
% pcfg.state = [500 1000 0 0]';
% 
% pcfg.stfswitch = [0];
% pcfg.stfs = {'identity'};
% 
% % Configure the state transition function
% identitycfg = stf_identitycfg; % Get the config 
% pcfg.stfcfgs{1} = identitycfg; % Subs. the config
% 
% sensorcfg1 = linobscfg; % Get the config
% alpha = -pi/6;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 8000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
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
% pcfg.state = [1500 1000 0 0]';
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
% alpha = pi/6;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 8000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
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
% pcfg.state = [1500 1000 0 0]';
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
% alpha = -pi/6;
% Rmat = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
% sensorcfg1.pd = 1;
% sensorcfg1.maxrange = 8000;
% sensorcfg1.orientation = [0 0 0];
% sensorcfg1.statelabels = {'x','y'};
% sensorcfg1.linTrans = [1 0;0 1];
% sensorcfg1.noiseCov =   Rmat*[0.3 0;0 0.7]*Rmat'*100;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 5;
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.
% 
% %%
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([2,3,4,5,6]');
% save simdata_linear_singletarget4.mat sim simcfg Xt

% % % % % % Now initiate a filter and run it
% % % % % 
load simdata_linear_singletarget4.mat

simremclut = sim;
for i=2:6
    sensor_ = simremclut.platforms{i}.sensors{1};
    sensor_.remclutter;
    simremclut.platforms{i}.sensors{1} = sensor_;
end
simremclut.draw
plotset( Xt, 'axis', gca,'options','''Color'',[0 0 1]')
% % 
% % % 
sensorObj1  =  sim.platforms{2}.sensors{1};
sensorObj2  =  sim.platforms{3}.sensors{1};
sensorObj3  =  sim.platforms{4}.sensors{1};
sensorObj4  =  sim.platforms{5}.sensors{1};
sensorObj5  =  sim.platforms{6}.sensors{1};

sensorObj1.insensorframe = 0;
sensorObj2.insensorframe = 0;
sensorObj3.insensorframe = 0;
sensorObj4.insensorframe = 0;
sensorObj5.insensorframe = 0;

sensorObj1.remclutter; 
sensorObj2.remclutter; 
sensorObj3.remclutter; 
sensorObj4.remclutter; 
sensorObj5.remclutter; 
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
%     
%     Zlist = [sensorObj1.srbuffer( stepcnt ),...
%         sensorObj2.srbuffer( stepcnt ),...
%         sensorObj3.srbuffer( stepcnt ),...
%         sensorObj4.srbuffer( stepcnt ),...
%         sensorObj5.srbuffer( stepcnt )];
%     filterObj.Z = Zlist;
%     filterObj.onestep( [sensorObj1, sensorObj2, sensorObj3,sensorObj4,sensorObj5] );

sensorObj1.insensorframe = 0;
Zlist = [sensorObj1.srbuffer( stepcnt )];
filterObj.Z = Zlist;
filterObj.onestep( [sensorObj1] );


%              sensorObj1.insensorframe = 1;
%              sensorObj2.insensorframe = 1;
%              sensorObj3.insensorframe = 1;
%             Zlist = [sensorObj1.srbuffer( stepcnt ),...
%                 sensorObj2.srbuffer( stepcnt ),...
%                 sensorObj3.srbuffer( stepcnt )];
%             filterObj.Z = Zlist;
%             filterObj.onestep( [sensorObj1, sensorObj2, sensorObj3], [[2000 0 0 0]', [500 1000 0 0]'] );
            
%     
%     sensorObj1.insensorframe = 0;
%     Zlist = [sensorObj1.srbuffer( stepcnt )];
%     filterObj.Z = Zlist;
%     filterObj.onestep( [sensorObj1] );
    
    
    Xh = filterObj.post.m;
        
    filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-5000,5000,-5000,5000]);ylabel(''y'')','clusters','legend'); pause(0.001);
    filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
    
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
plotset( Xt(strt:numsteps), 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs,'axis',gca,'options','''Color'',[1 0 0]')

figure
plotset( Xt(strt:numsteps),'dims',[3 4]', 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xhs, 'dims',[3 4]', 'axis',gca,'options','''Color'',[1 0 0]')  

ed1 = [];
eds = [];
for k=1:length(Xt(strt:numsteps))
    Xt_ = Xt{k}([1,2],:);
    Xh_ = Xhs{k}([1,2],:);
    ed1(k) = norm(Xt_-Xh_);
    eds(k) = norm( sensorObj1.srbuffer(k).Z.Z - Xt_);
end

figure
set(gcf,'Color',[1 1 1])
hold on
grid on
plot(ed1,'k')
plot(eds,'r')
xlabel('time step (s)')
ylabel('Euclidean distance (m)')
