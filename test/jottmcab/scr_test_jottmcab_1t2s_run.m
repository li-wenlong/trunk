% Configure
deltat = 1;
filtercfg = jottmcabcfg;
filtercfg.numpartnewborn = 500; % Number of particles for new target candidates
filtercfg.numpartpersist = 2000; % Number of particles for persistent targets
filtercfg.probbirth = 0.0009; %1.0;%
filtercfg.probsurvive = 0.98;
filtercfg.probdetection = 0.99;
filtercfg.speedminmax = { [176.6, -176.6]' , [20^2 0;0 20^2]};

filtercfg.veldist = gmm(1',gk( [220^2 0;0 220^2], [ 0 0]'));
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
modelcfg.Q = 10*10*[...
    deltat^3/3 0 deltat^2/2 0;...
    0 deltat^3/3 0 deltat^2/2;...
    deltat^2/2 0 deltat 0;...
    0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
% Initialise
jottfiltershadow = jottmcab(filtercfg); % cphd particle birth with detected process cardinality

% Load the scenario; i.e., sim
load test_sim_1t2s_b_PD095.mat
% Get the sensor object of the simulation 
sensorObj  =  sim.platforms{2}.sensors{1};

% load test_sim_4t2s_b_PD085_#2.mat
% sensorObj  =  sim.platforms{5}.sensors{1};

filterObj  = jottfiltershadow;

%if ~exist('isResetDefaultStream')
%stream = RandStream.getDefaultStream;
%reset(stream);
%isResetDefaultStream = 1;
%end

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


disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps 
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    Xh = filterObj.mosestodc;
    
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-5000,5000,-5000,5000]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-300,300,-300,300]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-5000,5000,-5000,5000]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-300,300,-300,300]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    fprintf('%d,',stepcnt);
    if mod(stepcnt,20)==0
        fprintf('\n');
    end

end

numdets = sensorObj.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );






