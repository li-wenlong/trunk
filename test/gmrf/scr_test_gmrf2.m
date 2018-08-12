% This script is to test the Gaussain Markov Random Field and Belief
% Propagation on an Undirected Network.


global DEBUG_GMRF DEBUG_GMRF_CARRAY DEBUG_VERBOSE
DEBUG_GMRF = 1;
DEBUG_VERBOSE = 1;



% Define the graph
V = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
E = [[1 2];[2 1];[1 4];[4 1];[1 6];[6 1];[1 8];[8 1];[2 3];[3 2];[2 9];[9 2];...
    [3 4];[4 3];[4 5];[5 4];[5 6];[6 5];[6 7];[7 6];[7 8];[8 7];[8 9];[9 8];...
    [9 10];[10 9];[10 11];[11 10];[2 11];[11 2];[11 12];[12 11];[12 3];[3 12];[12 13];[13 12];...
    [13 14];[14 13];[14 3];[3 14];[15 14];[14 15];[15 4];[4 15];[15 16];[16 15];[16 5];[5 16]];

% Ground truth for the unknowns
Thetas = [[0 0];[1000 0];[1000 1000];[0 1000];[-1000 1000];...
    [-1000 0];[-1000 -1000];[0 -1000];[1000 -1000];...
    [2000 -1000];[2000 0];[2000 1000];[2000 2000];...
    [1000 2000];[0 2000];[-1000 2000]];

% Dimensionality of the unknowns
dims = 2;

mygmrfcfg = gmrfcfg;
mygmrfcfg.V = V;
mygmrfcfg.E = E;

mygmrfcfg.mschedule = {E,E,E,E,E};

% Below, we find the distribution p(X| Y = 0) the marginals of which are
% those we would like to have finally
mu_x = Thetas';
mu_x = mu_x(:);
p_x = getgaussmrf( V, E, mu_x, dims, 0.1 );


% Marginals of the global model
% These are the distributions LBP will estimate
for l=1:length( V )
    pm( l ) = p_x.marginalise( [ (V(l)-1)*dims+1:V(l)*dims] );
end

% These are the initial coniditions
p0s(1) = cpdf( gk( eye(dims)*100,Thetas(1,:) ) ); % This is the given
for l=2:length( V )
    p0s( l ) = cpdf( gk( eye(dims)*10000, Thetas(l,:)) );
end

%% Find the edge potentials
epots = findedgepots( p_x, E, dims*ones(length(V),1) ); % Find edge potential functions given the whole model

y_samples = Thetas';

% Configure node objects 
for l=1:length( V )
    mynodecfg = nodecfg;
    mynodecfg.state = p0s( l );
    mynodecfg.noisedist = cpdf( gk( eye(dims)*1, zeros(dims,1)) );
    nodecfgs(l) = mynodecfg;
end

mygmrfcfg.nodes = nodecfgs;
mygmrfcfg.edgepotentials = epots;

mygraph = gmrf( mygmrfcfg );

for i=1: length( mygraph.nodes )
    mynode = mygraph.nodes(i);
    mynode = mynode.recmeas( y_samples(:,i) ); %Find the myopic posterior and store under @node.state
    
    myopicpost(i) = mynode.getmyopicpost; % store the myopic posteriors
    
    mygraph.nodes(i) = mynode;
end

% Perform Belief Propagation
mygraph = mygraph.bp;

% Get the BP results, i.e., estimates for poterior marginals
postmargs_bp = [ mygraph.nodes.state ]; % take the state fields of the nodes array in an array of its own

% Below, the centralised posteriors are found

%% Plot, now, the priors, myopic, bp and centralised posteriors

fhandle = figure;
cla;
xlabel('East (m)','FontSize',14)
ylabel('North (m)','FontSize',14)
axis([-1500 2500 -1500 2500])
drawgeograph( Thetas, E,  'AxisHandle', gca, 'Linewidth',0.1 )

mymap = linspecer(length( V ));
for i=1:length( V )
    % Plot the BP estimated posterior marginal
    optStr = ['''Color'',[',num2str(mymap(i,:)), '],''LineStyle'',''-'''];
   
    [ahandle, fighandle] = postmargs_bp(i).draw('axis', gca,'dims',[1 2], 'options',  optStr );
    % Plot the initial state
    optStr = ['''Color'',[',num2str(mymap(i,:)), '],''LineStyle'','':'''];
    [ahandle, fighandle] = mygraph.nodes(i).initstate.draw('axis', gca, 'dims',[1 2], 'options', optStr );
    
    % Plot the myopic posterior
    optStr = ['''Color'',[',num2str(mymap(i,:)), '],''LineStyle'',''-.'''];
    [ahandle, fighandle] = myopicpost(i).draw('axis', gca, 'dims',[1 2], 'options', optStr );
    drawnow;    
end



% Below, the BP updates as scheduled, are shown.
figure
mymap = linspecer(length( V ));
for j=1:length(DEBUG_GMRF_CARRAY)
    cla;
    hold on
    grid on
    
    drawgeograph( Thetas, E,  'AxisHandle', gca, 'Linewidth',0.1 )
    drawnow;
      
    xlabel('East (m)','FontSize',14)
    ylabel('North (m)','FontSize',14)
    axis([-1500 2500 -1500 2500])
    
    graphj = DEBUG_GMRF_CARRAY{j};
    
    rgbobj = rgb;
    for i=1:length( graphj.V )
        col = mymap(i,:);
        
        optStr = ['''Color'',[',num2str(col), '],''LineStyle'','':'''];
        [ahandle, fighandle] = graphj.nodes(i).state.draw('axis', gca, 'dims',[1 2], 'options', optStr );
        
      
    end
    drawnow;
    pause(1)
end

