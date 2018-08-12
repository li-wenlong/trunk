% This script is to test the Continuous Markov Random Field class pmrf
% with particle belief node class pnode using 
% Belief Propagation on an Undirected Network
% The test example is similar to the localisation problem

global DEBUG_PMRF DEBUG_PMRF_CARRAY DEBUG_VERBOSE
DEBUG_PMRF = 1;
DEBUG_VERBOSE = 1;



% Define the graph
V = [1,2,3,4,5,6,7,8,9];
E = [[1 2];[2 1];[1 4];[4 1];[1 6];[6 1];[1 8];[8 1];[2 3];[3 2];[2 9];[9 2];...
    [3 4];[4 3];[4 5];[5 4];[5 6];[6 5];[6 7];[7 6];[7 8];[8 7];[8 9];[9 8]];

% Ground truth for the unknowns
Thetas = [[0 0];[1000 0];[1000 1000];[0 1000];[-1000 1000];...
    [-1000 0];[-1000 -1000];[0 -1000];[1000 -1000]];

% Dimensionality of the unknowns
dims = 2;

mypmrfcfg = pmrfcfg;
mypmrfcfg.V = V;
mypmrfcfg.E = E;

mypmrfcfg.mschedule =  {[[1 2];[1 4];[1 6];[1 8]],...
     [[2 3];[2 9];[4 3];[4 5];[6 5];[6 7];[8,7];[8,9]],...
     [[1 2];[1 4];[1 6];[1 8];[2 3];[2 9];[4 3];[4 5];[6 5];[6 7];[8,7];[8,9];[3 4];[3 2];[9 8];[9 2];[7 8];[7 6];[5 6];[5 4]],...
     [[1 2];[1 4];[1 6];[1 8];[2 3];[2 9];[4 3];[4 5];[6 5];[6 7];[8,7];[8,9];[3 4];[3 2];[9 8];[9 2];[7 8];[7 6];[5 6];[5 4]]};


mypmrfcfg.uschedule = { [2,4,6,8],...
    [3,5,7,9],...
    [2,3,4,5,6,7,8,9],...
    [2,3,4,5,6,7,8,9]};
 

for j=1:6
    mypmrfcfg.mschedule{end+1}=mypmrfcfg.mschedule{end};
    mypmrfcfg.uschedule{end+1}=mypmrfcfg.uschedule{end};
end

% Below is the distribution we would like to have finally
mu_x = Thetas';
mu_x = mu_x(:);
p_x = gk( eye( length(mu_x)  ), mu_x );
E = mypmrfcfg.E;

% Find the symmetric edge potentials
% that would force LBP to the marginals of the above
epotobjs = getsymedgepots( p_x, E, dims ); % Find edge potential functions given the whole model
% Now, the function pointers to evaluate \psi(x_i,x_j)s
numedges = size( E,1);
for l=1:numedges
    epotfuncts{l} = @symedgepotsampler;
end


% Initial node states:
p0s(1) = cpdf( gk( eye(dims)*0.1,Thetas(1,:) ) ); % This is the given
for l=2:length( V )
    p0s( l ) = cpdf( gk( eye(dims)*10000, Thetas(l,:)*0.5 ) );
end

%% Particle represented PMRF configuration
mypmrfcfg.epotobjs = epotobjs;
mypmrfcfg.edgepotentials = epotfuncts;


% Configure node objects 
numsamples = 60;
for l=1:length( V )
    mynodecfg = pbnodecfg;
    mynodecfg.state = particles('states', p0s(l).gensamples(numsamples),'labels', l );
    mynodecfg.state = mynodecfg.state.findkdebws;
    nodecfgs(l) = mynodecfg;
end

% Save the node configurations
mypmrfcfg.nodes = nodecfgs;
% initiate a pmrf object
mygraph = pmrf( mypmrfcfg );
% belief prop. with a schedule
mygraph = mygraph.bpsch;

% Get the BP results, i.e., estimates for poterior marginals
postmargs_bp = mygraph.nodes(1).state;
priormargs_bp = mygraph.nodes(1).initstate;
for i=2:mygraph.N
    postmargs_bp(i) = [ mygraph.nodes(i).state ]; % take the state fields of the nodes array in an array of its own
    priormargs_bp(i) = [mygraph.nodes(i).initstate ];
end
% Compare the bp states with prior posterior marginals
% These should be the same for this example (since the bp iterations start



% Below, the BP updates as scheduled, are shown.
figure
for j=1:length(DEBUG_PMRF_CARRAY)
    
    cla;
    xlabel('East (m)','FontSize',14)
    ylabel('North (m)','FontSize',14)
    axis([-1500 1500 -1500 1500])
    
    graphj = DEBUG_PMRF_CARRAY{j};
    
    drawgeograph( Thetas, E,  'AxisHandle', gca, 'Linewidth',1 )
    
    hold on
    grid on
    rgbobj = rgb;
    for i=1:length( V )
        col = rgbobj.getcoln(10+i);
        
        
        % find the 25m radius line around the sensors.
        rhos = [0:pi/100:2*pi];
        [cxs,cys] = pol2cart( rhos, ones(size(rhos))*30 );
        
        plot( cxs+ Thetas(i,1), ...
            cys +  Thetas(i,2),...
            'Color',[0 0 1],'MarkerSize',1,'Marker','.','Linewidth',2,'linestyle',':' );
        
        xy = graphj.nodes(i).initstate.states;
        l1 = plot( xy(1,:), xy(2,:), 'color',[0.5 0.5 0.5],'marker','s','linestyle','none','MarkerSize',4,'Linewidth',1 );
        
        
        xy = graphj.nodes(i).state.states;
        l2 = plot( xy(1,:), xy(2,:), 'color',col,'marker','x','linestyle','none','MarkerSize',8,'Linewidth',2 );
        
        drawnow;
    end
    pause(0.1);
    drawnow;
end
legend([l1,l2],'prior','post marg');