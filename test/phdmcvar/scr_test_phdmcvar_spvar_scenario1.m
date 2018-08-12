% Configure
deltat = 1;
filtercfg = phdmcvarcfg;
filtercfg.numpartnewborn = 500; % Number of particles for new target candidates
filtercfg.numpartpersist = 750; % Number of particles for persistent targets
filtercfg.probbirth = 0.009; %1.0;%
filtercfg.probsurvive = 0.95;
filtercfg.probdetection = 0.95;

filtercfg.veldist = gmm(1',gk( [10^2 0;0 10^2], [ 0 0]'));

modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 0.25*[...
    deltat^3/3 0 deltat^2/2 0;...
    0 deltat^3/3 0 deltat^2/2;...
    deltat^2/2 0 deltat 0;...
    0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
filtercfg.regflag = 1;

filtercfg.regions = region('circular',[0 0],10000 );


% Initialise
phdfilter = phdmcvar(filtercfg); % cphd particle birth with detected process cardinality
initphdfilter = phdfilter;   % initial filter

% Load the scenario; i.e., sim
load  simdata_spvar_scenario1_#4.mat
% Get the sensor object of the simulation 
sensorObj  =  sim.platforms{9}.sensors{1};


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
%%%%%%%%%%%%%%%%%%%%%%%%%%

if displayon || scatterploton
    axisHandles = filterObj.getaxis('all');
end

varfig = figure;
vardxfig = figure;

varads = [1:1:100]; % Radii of the circular regions for variance computations
tarpos = [0 0]';

Xh1s = {};
disp(sprintf('Filtering the buffer of length %d :', numsteps));
for stepcnt = 1:numsteps
    
    % Specify the regions over which the variance is to be computed
    tarpos = Xt{stepcnt}; % target positions
    regs = region([]);
    for k=1:size(tarpos,2)
        numrads = length( varads );
        for rcnt = 1:numrads
            regs( (k-1)*numrads + rcnt ) = region('circular', tarpos([1,2], k), varads(rcnt) );
        end
    end
    filterObj.regions = regs;
    
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    Xh = filterObj.mosestodc;
    Xh1s = [Xh1s, {Xh}];
    if displayon
        filterObj.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-8500,8500,-8500,8500]);view([-15,75]);ylabel(''y'')');pause(0.001);
        filterObj.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-300,300,-300,300]);view([-15,75]);ylabel(''y'')');pause(0.001);
    elseif scatterploton
        filterObj.scplotbuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-8500,8500,-8500,8500]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filterObj.scplotbuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-300,300,-300,300]);ylabel(''y'')','clusters','legend'); pause(0.001);
    end
    plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
    plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
    
    figure(varfig )
    if ~isempty( filterObj.vars )
        clf;
        hold on
        plot( filterObj.vars )
        plot( filterObj.mus,'r' )
    end
    
    figure(vardxfig )
    if ~isempty( filterObj.vardx )
        clf;
        hold on
        plotcmap( filterObj.vardx.s.particles.states, filterObj.vardx.s.particles.weights*filterObj.vardx.mu ,'axis', gca,...
            'postcommands','axis([-8500,8500,-8500,8500])');
        colorbar;
    end
    drawnow;
    fprintf('%d,',stepcnt);
    if mod(stepcnt,20)==0
        fprintf('\n');
    end

end

figure
plotset( Xt, 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xh1s ,'axis',gca,'options','''Color'',[0 1 1]')
figure
plotset( Xt,'dims',[3 4], 'axis', gca, 'options','''Color'',[0 0 0],''LineStyle'',''none'',''Marker'',''x''');
plotset( Xh1s ,'dims',[3 4],'axis',gca,'options','''Color'',[0 1 1]')

a = 750;
 b = 1;
[ospacombf1, ospalocf1, ospacardf1] = calcOSPAseries( Xt, Xh1s, a, b );

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

numdets = sensorObj.numdets;
[numtargmap, numtargmse ] = filterObj.estnumtarg; % Get the estimate of number of targets vs. time step
numests = numtargs( Xh1s );

figure
axis([0, length(numdets)-1, 0 max( [max(numdets), max(numtargmap), max(numtargmse) ] )])
hold on
grid on
plot( [0:length(numdets)-1], numdets, 'k' );
plot( [0:length(numdets)-1], numtargmap, 'b' );
plot( [0:length(numdets)-1], numtargmse, 'r' );
plot( [0:length(numests)-1], numests, 'c' );
legend('true','MAP','MSE','|\hat X|')





