% Configure
deltat = 1;
filtercfg = phdmcabcfg;
filtercfg.numpartnewborn = 75; % Number of particles for new target candidates
filtercfg.numpartpersist = 300; % Number of particles for persistent targets
filtercfg.probbirth = 0.0009; %1.0;%
filtercfg.probsurvive = 0.97;
filtercfg.probdetection = 0.95;
filtercfg.regflag = 1;

%filtercfg.veldist = gmm(1',gk( [100^2 0;0 100^2], [ 0 0]'));
filtercfg.veldist = gmm(1',gk( [(8/3)^2 0;0 (8/3)^2], [ 0 0]'));
modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
% modelcfg.Q = 10*10*[...
%     deltat^3/3 0 deltat^2/2 0;...
%     0 deltat^3/3 0 deltat^2/2;...
%     deltat^2/2 0 deltat 0;...
%     0 deltat^2/2 0 deltat];
modelcfg.Q = 0.025*[...
    deltat^3/3 0 deltat^2/2 0;...
    0 deltat^3/3 0 deltat^2/2;...
    deltat^2/2 0 deltat 0;...
    0 deltat^2/2 0 deltat];



filtercfg.targetmodelcfg = modelcfg;
     
% Initialise
phdfilter = phdmcab(filtercfg); % cphd particle birth with detected process cardinality
initcphdfilter = phdfilter;   % initial filter

% Load the scenario; i.e., sim
load simdata_6t2s_icassp.mat

% Get the sensor object of the simulation 
sensor1 = sim.platforms{7}.sensors{1};
sensor2 = sim.platforms{8}.sensors{1};
% Bias the sensor measurements
% bias1 = rbmeas;
% bias1.range = 7.2;
% bias1.bearing = -3.5*pi/180;
% 
% bias2 = rbmeas;
% bias2.range = -5;
% bias2.bearing = 2*pi/180;


%sensor1.biasbuffer(bias1);
%sensor2.biasbuffer(bias2);
%sensor1.remclutter;
%sensor2.remclutter;

filterObj  = initcphdfilter;

if ~exist('isResetDefaultStream')
stream = RandStream.getDefaultStream;
reset(stream);
isResetDefaultStream = 1;
end

% Use onestep
numsteps = length( sensor1.srbuffer );

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

Xhs = {};
disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps 
    
    mdcnt = mod( stepcnt-1, 2 ) +1 ;
    if mdcnt == 1
        filterObj.Z = sensor1.srbuffer( stepcnt );
        filterObj.onestep( sensor1 );
    else
        filterObj.Z = sensor2.srbuffer( stepcnt );
        filterObj.onestep( sensor2 );
    end
    
    
    Xh = filterObj.mosestodc;
    Xhs{stepcnt} = Xh;
    
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-300,300,-300, 300]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-10,10,-10,10]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-300,300,-300, 300]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-10,10,-10,10]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt,20)==0
        fprintf('\n');
    end

end

a = 1;
 b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xhs, a, b );

figure
subplot(311)
hold on 
grid on
plot(ospacombf1,'k')
ylabel('OSPA comb.')

subplot(312)
hold on 
grid on
plot(ospalocf1,'k')
ylabel('OSPA loc.')

subplot(313)
hold on 
grid on
plot(ospacardf1,'k')
ylabel('OSPA card.')

figure
plotset(Xt,'axis',gca,'options','''Marker'',''.'',''Color'',[0 0 0],''LineStyle'',''None''');
plotset(Xhs,'axis',gca, 'options','''Marker'',''o'',''Color'',[1 0 0],''LineStyle'',''None''');

figure
plotset(Xt,'dims',[3 4],'axis',gca,'options','''Marker'',''.'',''Color'',[0 0 0],''LineStyle'',''None''');
plotset(Xhs,'dims',[3 4],'axis',gca, 'options','''Marker'',''o'',''Color'',[1 0 0],''LineStyle'',''None''');


numdets = sensor1.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );






