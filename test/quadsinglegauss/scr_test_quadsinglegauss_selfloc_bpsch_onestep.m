% This script is for testing the @pmrf class in the self localisation
% problem

global DEBUG_MISC

global DEBUG_PMRF DEBUG_PMRF_CARRAY DEBUG_VERBOSE
DEBUG_PMRF = 1;
DEBUG_VERBOSE = 1;
DEBUG_MISC = 1;


% Define the graph
V = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
E = [[1 2];[2 1];[1 4];[4 1];[1 6];[6 1];[1 8];[8 1];[2 3];[3 2];[2 9];[9 2];...
    [3 4];[4 3];[4 5];[5 4];[5 6];[6 5];[6 7];[7 6];[7 8];[8 7];[8 9];[9 8];...
    [9 10];[10 9];[10 11];[11 10];[2 11];[11 2];[11 12];[12 11];[12 3];[3 12];[12 13];[13 12];...
    [13 14];[14 13];[14 3];[3 14];[15 14];[14 15];[15 4];[4 15];[15 16];[16 15];[16 5];[5 16]];


% Dimensionality of the unknowns
dims = 2;

datfilename = 'simdata_linear_singletarget4pmrf.mat';


mypmrfcfg = pmrfcfg;
mypmrfcfg.V = V;
mypmrfcfg.E = E;

mypmrfcfg.mschedule =  {[[1 2];[1 4];[1 6];[1 8]],...
     [[2 3];[2 9];[2 11];[4 3];[4 5];[4 15];[6 5];[6 7];[8,7];[8,9]],...
     [[5 16];[15 16];[15 14];[3 14];[3,12];[9 10]],...
     [[14 13];[12 13];[12 11];[10 11]],...
     [[1 2];[2 1];[1 4];[4 1];[1 6];[6 1];[1 8];[8 1];[2 3];[3 2];[2 9];[9 2];...
    [3 4];[4 3];[4 5];[5 4];[5 6];[6 5];[6 7];[7 6];[7 8];[8 7];[8 9];[9 8];...
    [9 10];[10 9];[10 11];[11 10];[2 11];[11 2];[11 12];[12 11];[12 3];[3 12];[12 13];[13 12];...
    [13 14];[14 13];[14 3];[3 14];[15 14];[14 15];[15 4];[4 15];[15 16];[16 15];[16 5];[5 16]]};


mypmrfcfg.uschedule = { [2,4,6,8],...
    [3,5,7,9,15],...
    [10,12,14,16],...
    [11,13],...
    [2:16]};
mypmrfcfg.itermax = 4;

% The following message and update schedule will be used if the first call
% is repeated
for cnt = 1:35
    mypmrfcfg.mschedule{end+1}=mypmrfcfg.mschedule{end};
    mypmrfcfg.uschedule{end+1}=mypmrfcfg.uschedule{end};
end

%% The edgeupdate schedule 
mypmrfcfg.euschedule = mypmrfcfg.mschedule;
mypmrfcfg.itermax = 4;

%% Now, configure the edge potentials
% 1) Load the simulation data file
if exist(datfilename)==2 
    % If data file exists
    load(datfilename); 
else
       % Sensor locations to use when generating data
Thetas = [[0 0];[1000 0];[1000 1000];[0 1000];[-1000 1000];...
    [-1000 0];[-1000 -1000];[0 -1000];[1000 -1000];...
    [2000 -1000];[2000 0];[2000 1000];[2000 2000];...
    [1000 2000];[0 2000];[-1000 2000]];
    scr_gensimdata
end

% Take the sensors and their locations in earth coordinate system
[sensors, loc] = sim.getsensors;
% Ground truth for the unknowns
Thetas = loc';
mu_x = Thetas';
mu_x = mu_x(:);
% 2) filter the sensor buffers
% a) Make sure that filtering of sensor buffers will be in the sensor frame
for i=1:length(sensors)
    sensori = sensors{i};
    sensori.insensorframe = 1;
    sensors{i} = sensori;
end
% b) Pick a filter configuration 
deltat = 1;
filtercfg = kfcfg;
filtercfg.veldist = cpdf( gk( [15^2 0;0 15^2], [0 0]') );

modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];

modelcfg.Q = 0.1*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;...
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

filtercfg.targetmodelcfg = modelcfg;
% c) initiate filters
filters{1} = kf(filtercfg);
for i=2:length(sensors)
    filters{i} = kf(filtercfg);
end

% d) filter the sensor buffers
[localposteriors, logsis, sidists, localpriors ] = fun_kalmanfiltersens( sensors, filters );

% select the time window to work on
T = 30;
winlength= 10;

Ts = [T-winlength+1:T];
timewindow = Ts;


% e) Configure objects the edge potentials

for l=1:size(E,1)
    myedgecfg = quadsinglegausscfg;
    myedgecfg.e = E(l,:);
    % Leave myedgecfg.thetas blank to be found as a grid, later
    myedgecfg.numthetas = 81;
    myedgecfg.dim = 2;
    myedgecfg.limits = [-1500 2500 -1500 2500 ];
    myedgecfg.potfun =  @symedgepotsampler;
    % myedgecfg.potobj will be updated later
    myedgecfg.updatefun = @quadedgepotupdate;
    myedgecfg.updateparams = {100, 10, 5, 1, 1, 1 }; % A buffer for parameters to be passed to update at each occasion
    
    myedgecfg.T = timewindow;
    
    myedgecfg.postis = localposteriors( timewindow, E(l,1) );
    myedgecfg.predis = localpriors( timewindow, E(l,1) );
    
    myedgecfg.postjs = localposteriors( timewindow, E(l,2) );
    myedgecfg.predjs = localpriors( timewindow, E(l,2) );
    
    myedgecfg.sensoricfg = sensors{ E(l,1) }.cfg;
    myedgecfg.sensorjcfg = sensors{ E(l,2) }.cfg;
        
    myedgecfg.sensorbufferi = sensors{ E(l,1) }.srbuffer(timewindow);
    myedgecfg.sensorbufferj = sensors{ E(l,2) }.srbuffer(timewindow);
    
    edgecfgs(l) = myedgecfg;
end

%3) Assign configuration
mypmrfcfg.edgepots = edgecfgs;

%% Configure node objects 
% 1) Find initial node state for the network centre:
p0s(1) = cpdf( gk( eye(dims)*0.00000001,Thetas(1,:) ) ); % This is the given
mynodecfg = pbnodecfg;
numsamples = 100;
mynodecfg.state = particles('states', p0s(1).gensamples(numsamples),'labels', l );
mynodecfg.state = mynodecfg.state.findkdebws;
nodecfgs(1) = mynodecfg;

% 2) Assign empty node states for the rest
for l=2:length( V )
    mynodecfg.state =  particles([]);
    nodecfgs(l) = mynodecfg;
end


% 3) Assign the node configurations
mypmrfcfg.nodes = nodecfgs;

%% initiate a pmrf object
mygraph = pmrf( mypmrfcfg );

%% Below is to go with BP one step at a time
while( mygraph.iternum < 10 )
    mygraph.itermax =  mygraph.iternum + 1;
    mygraph = mygraph.bpsch;
    
    if mygraph.iternum == 4
        % save belief sates as priors
        mygraph.state2init;
    end
    
end

% Get the BP results, i.e., estimates for poterior marginals
postmargs_bp = mygraph.nodes(1).state;
priormargs_bp = mygraph.nodes(1).initstate;
for i=2:mygraph.N
    postmargs_bp(i) = [ mygraph.nodes(i).state ]; % take the state fields of the nodes array in an array of its own
    priormargs_bp(i) = [mygraph.nodes(i).initstate ];
end

% Below, the BP updates as scheduled, are shown.
figure
mymap = linspecer(length( V ));
for j=1:length(DEBUG_PMRF_CARRAY)
    
    cla;
    xlabel('East (m)','FontSize',14)
    ylabel('North (m)','FontSize',14)
    axis([-1500 2500 -1500 2500])
    
    graphj = DEBUG_PMRF_CARRAY{j};
    
    drawgeograph( Thetas, E,  'AxisHandle', gca, 'Linewidth',1 )
    
    hold on
    grid on
    rgbobj = rgb;
    for i=1:length( V )
        col = mymap(i,:);
        
        
        % find the 25m radius line around the sensors.
        rhos = [0:pi/100:2*pi];
        [cxs,cys] = pol2cart( rhos, ones(size(rhos))*30 );
        
        plot( cxs+ Thetas(i,1), ...
            cys +  Thetas(i,2),...
            'Color',col,'MarkerSize',1,'Marker','.','Linewidth',2,'linestyle',':' );
        
        xy = priormargs_bp(i).states;
        l1 = plot( xy(1,:), xy(2,:), 'color',[0.5 0.5 0.5],'marker','s','linestyle','none','MarkerSize',2,'Linewidth',0.5 );
        
        if ~isempty( graphj.nodes(i).state )
            xy = graphj.nodes(i).state.states;
            l2 = plot( xy(1,:), xy(2,:), 'color',col,'marker','x','linestyle','none','MarkerSize',8,'Linewidth',2 );
        end
        
        drawnow;
    end
    pause(1);
    drawnow;
end
legend([l1,l2],'prior','post marg');


% Find the MSE
err = [];
errn = [];
rses = [];
stpcnts = [5:length( DEBUG_PMRF_CARRAY)];
for cnt=1:length( stpcnts )
    k = stpcnts( cnt ) ;
    graphj = DEBUG_PMRF_CARRAY{k};
    est = graphj.mseest;
    err_ = est - mu_x;
    err(end+1,:) = err_;
    errn(end+1)  = sqrt( sum(err_.^2) );
    
    for i=1:length(V)
       rses(i,cnt) = sqrt( sum( err_( dims*(i-1)+1:dims*i).^2 ) ); 
        
    end
end


figure
subplot(211)
plot( stpcnts, log10(errn) )
axis([0, max(stpcnts), min(0,1.25*log10(min(errn)) ), max( 0, 1.25*log10(max(errn)))])
xlabel('iteration')
ylabel('log RSE')
subplot(212)
plot( stpcnts, (errn) )
axis([0, max(stpcnts), min(0,1.25*(min(errn)) ), max( 0, 1.25*(max(errn)))])
xlabel('iteration')
ylabel('RSE')


figure
hold on
grid on
rgbobj = rgb;
for i=1:length( V )
    plot( stpcnts, rses(i,:),'Color',rgbobj.getcol )
end

axis([0, max(stpcnts), 0, 1.25*max(max(rses))])
xlabel('iteration')
ylabel('RSEs')


figure
hold on
grid on
rgbobj = rgb;
for i=1:length( V )
    plot( stpcnts, log10( rses(i,:) ),'Color',rgbobj.getcol )
end
axis([0, max(stpcnts), log10( min(min(rses)) ), log10( max(max(rses)) )])
xlabel('iteration')
ylabel('log RSEs')

% Below is the graph for elapsed times during edge updates
graphj = DEBUG_PMRF_CARRAY{end};
figure
hold on 
grid on
rgbobj = rgb;
for i=1:length( E )
    plot( graphj.edgepots(i).tupdate,'Color',rgbobj.getcol,'Marker','x' );
end
xlabel('iteration')
ylabel('elapsed time (s)')



