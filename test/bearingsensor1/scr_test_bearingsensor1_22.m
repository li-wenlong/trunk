% This script invokes the constructor and init method of the
% Multi sensor multi object simulation class msmosim


% 
% 
% % Here, Bearings only sensors are used 
% simcfg = msmosimcfg;
% simcfg.tstart = 0;
% simcfg.tstop = 60;
% simcfg.deltat = 1;
% 
% %% Configure platform 1 w/ source
% deltat = 0.1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [2800 3000 0 -20]';
% 
% pcfg.stfswitch = [0,60];
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
% %% Configure platform 2 w/ source
% deltat = 0.1;
% pcfg = platformcfg;
% pcfg.statelabels = {'x','y','vx','vy'};
% pcfg.state = [4200 7310 -16 -10]';
% 
% pcfg.stfswitch = [0,60];
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
% sensorcfg1 = bearingsensor1cfg; % Get the config
% sensorcfg1.pd = 1.0;
% sensorcfg1.stdang = 1*pi/180;
% sensorcfg1.maxrange = 10000;
% sensorcfg1.minrange = 100;
% sensorcfg1.alpha = 180*pi/180;
% sensorcfg1.orientation = [30*pi/180 0 0];
% sensorcfg1.detonlynear = 1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.01;
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
% pcfg.state = [3000 7600 0 0]';
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
% sensorcfg1.maxrange = 10000;
% sensorcfg1.minrange = 100;
% sensorcfg1.alpha = 180*pi/180;
% sensorcfg1.orientation = [-45*pi/180 0 0];
% sensorcfg1.detonlynear = 1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.01;
% 
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
% pcfg.state = [7000 0 0 0]';
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
% sensorcfg1.maxrange = 10000;
% sensorcfg1.minrange = 100;
% sensorcfg1.alpha = 180*pi/180;
% sensorcfg1.orientation = [135*pi/180 0 0];
% sensorcfg1.detonlynear = 1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.01;
% 
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
% pcfg.state = [6000 0 0 0]';
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
% sensorcfg1.stdang = 2*pi/180;
% sensorcfg1.maxrange = 10000;
% sensorcfg1.minrange = 100;
% sensorcfg1.alpha = 180*pi/180;
% sensorcfg1.orientation = [150*pi/180 0 0];
% sensorcfg1.detonlynear = 1;
% 
% clutcfg = poisclut2cfg;
% clutcfg.lambda = 0.01;
% 
% 
% sensorcfg1.cluttercfg = clutcfg;
% 
% pcfg.sensorcfgs{1} = sensorcfg1; % Subs, the config
% 
% simcfg.platformcfgs{6} = pcfg; % Subs the plat cfg.
% 
% 
% sim = msmosim( simcfg );
% sim.run;
% [Xt, numxt] = sim.getmostates([3,4,5, 6]');
% save bearingsensortestdata22.mat sim simcfg Xt

% % Now initiate a filter and run it
% 
load bearingsensortestdata22.mat
sensorObj1  =  sim.platforms{3}.sensors{1};
sensorObj1.remclutter; 
sensorObj2  =  sim.platforms{4}.sensors{1};
sensorObj2.remclutter; 
sensorObj3  =  sim.platforms{5}.sensors{1};
sensorObj3.remclutter; 
sensorObj4  =  sim.platforms{6}.sensors{1};
sensorObj4.remclutter; 


sensors = [sensorObj1, sensorObj2, sensorObj3, sensorObj4];

selsensors = [2,4,1,3];
selsensors = [1,3,2,4];

sensors = sensors(selsensors);


numsensors = length(sensors );
splotHandle = figure;
sensors.draw('figure',splotHandle);

%%%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = phdmcabcfg;
filtercfg.numpartnewborn = 400; % Number of particles for new target candidates
filtercfg.numpartpersist = 1500; % Number of particles for persistent targets
filtercfg.probbirth = 0.003;
filtercfg.probsurvive = 0.97;
filtercfg.probdetection = 0.99;
filtercfg.regflag = 0;
 
velstd = 15;
filtercfg.veldist = gmm(1',gk( [velstd^2 0;0 velstd^2], [ 0 0]') );
        
% 
modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
qgain = 0.005;
modelcfg.Q = qgain*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... 
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
initcphdfilter = phdmcab(filtercfg);
 
filterObj  = initcphdfilter;

if ~exist('isResetDefaultStream')
stream = RandStream.getDefaultStream;
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
%%%%%%%%%%%%%%%%%%%%%%%%%

if displayon || scatterploton
    axisHandles = filterObj.getaxis('all');
end

Xhs = {};

[fschedule] = fun_filtschedule( sensors );
numsteps = length(fschedule.ts);

disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps 
       
     % Modify the state transition
    if stepcnt>1
        deltat = fschedule.ts(stepcnt)-fschedule.ts(stepcnt-1);
                
        modelcfg.deltat = deltat;
        modelcfg.F = [1 0 1*deltat 0;...
            0 1 0 1*deltat;...
            0 0 1 0;...
            0 0 0 1];
        modelcfg.Q = qgain*[...
            deltat^3/3 0 deltat^2/2 0;...
            0 deltat^3/3 0 deltat^2/2;...
            deltat^2/2 0 deltat 0;...
            0 deltat^2/2 0 deltat];
 
        filtercfg.veldist = gmm(1',gk( [velstd^2 0;0 velstd^2], [ 0 0]') );
        filterObj.targetmodel = stf_lingauss( modelcfg );
        
    end
    
    srlist = [];
    for i=1:length( fschedule.senschedule{stepcnt} )
        srlist = [srlist, sensors( fschedule.senschedule{stepcnt}(i) ).srbuffer( fschedule.srptrall{stepcnt}(i) ) ];
    end
    
    filterObj.Z = srlist;
    
    
    %   if upd == 0
    filterObj.onestep( sensors( fschedule.senschedule{stepcnt} ) );
        
    Xh = filterObj.mosestodc;
    
    
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([0,10000,0,10000]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-50,50,-50,50]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([0,10000,0,10000]);ylabel(''y'')','clusters','legend'); pause(0.001);
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

figure(splotHandle)
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




numdets = sensorObj1.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );




% Plot by clearing axis
lobopt = {'-b','-r','-g','-m','-k'};
spopt = {'xb','xr','xg','xm','xk'};
maxrange = 10000;
figure
a1 = gca;
axis([-0 maxrange -0 maxrange])
hold on
grid on

a2 = axes('position',[0.85,0.85, 0.1, 0.1]);
axis off


for i=1:length(fschedule.ts)
   
    axes( a1 );
    cla;
       
    for j=1:length( fschedule.senschedule{i} )
        
        bearings = cell2mat({ sensors( fschedule.senschedule{i}(j) ).srbuffer( fschedule.srptrall{i}(j) ).Z.bearing});
        for k=1:length( bearings )
        aoa =  bearings(k) + ...
            sensors( fschedule.senschedule{i}(j) ).orientation(1);
        xmax = maxrange*cos(aoa);
        ymax = maxrange*sin(aoa);
        x_enu = sensors( fschedule.senschedule{i}(j) ).srbuffer( fschedule.srptrall{i}(j) ).pstate.state(1);
        y_enu = sensors( fschedule.senschedule{i}(j) ).srbuffer( fschedule.srptrall{i}(j) ).pstate.state(2);
        % plot the line of bearing
        plot( [x_enu, x_enu+xmax ],[y_enu y_enu+ymax], lobopt{ fschedule.senschedule{i}(j) })
        
        end
        % plot the sensor position
        plot( x_enu, y_enu,spopt{ fschedule.senschedule{i}(j)})
        
       
    end
    if exist('Xhs')
        plotset(Xhs{i},'axis',gca,'options','''Color'',[0 0 0],''linewidth'',3')
        axis([-0 maxrange -0 maxrange])
        hold on
        grid on
        %zoom(2)
    end
    % Write the time
    axes(a2);
    cla
    text(0,0,num2str(fschedule.ts(i)));
    
       
    pause(0.5)
end






% 




