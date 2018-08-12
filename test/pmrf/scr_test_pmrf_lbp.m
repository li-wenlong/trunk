% This script is to test the Continuous Markov Random Field class pmrf
% with particle belief node class pnode using 
% Belief Propagation on an Undirected Network
% The test example is similar to the localisation problem

global DEBUG_PMRF DEBUG_PMRF_CARRAY DEBUG_VERBOSE
DEBUG_PMRF = 1;
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

mypmrfcfg = pmrfcfg;
mypmrfcfg.V = V;
mypmrfcfg.E = E;
mypmrfcfg.itermax = 10;

% Below is the distribution we would like to have finally
mu_x = Thetas';
mu_x = mu_x(:);
p_x = getgaussmrf( V, E, mu_x, dims, 0.1 );



%% Configure the edge potentials

% 1) Find the symmetric edge potentials
% that would force LBP to the marginals of the above
epotgks = getsymedgepots( p_x, E, dims ); % Find edge potential functions given the whole model

% 2) Configure objects the edge potentials
for l=1:size(E,1)
    myedgecfg = edgepotcfg;
    myedgecfg.e = E(l,:);
    myedgecfg.potfun =  @symedgepotsampler;
    myedgecfg.potobj = epotgks{ l };
    edgecfgs(l) = myedgecfg;
end

%3) Assign configuration
mypmrfcfg.edgepots = edgecfgs;

%% Configure node objects 
% 1) Find initial node states
p0s(1) = cpdf( gk( eye(dims)*0.00001,Thetas(1,:) ) ); % This is the given
for l=2:length( V ) 
    p0s( l ) = cpdf( gk( eye(dims)*40000, 0.5*Thetas(l,:)) );
end

mynodecfg = pbnodecfg;
numsamples = 100;
mynodecfg.state = particles('states', p0s(1).gensamples(numsamples),'labels', l );
mynodecfg.state = mynodecfg.state.findkdebws;
nodecfgs(1) = mynodecfg;

% 2) Assign empty node states for the rest
for l=2:length( V )
    mynodecfg.state = particles('states', p0s(l).gensamples(numsamples),'labels', l );
    mynodecfg.state = mynodecfg.state.findkdebws;
    nodecfgs(l) = mynodecfg;
end

% 3) Assign the node configurations
mypmrfcfg.nodes = nodecfgs;

%% initiate a pmrf object
mygraph = pmrf( mypmrfcfg );
% loopy belief prop.
mygraph = mygraph.lbp;

% Get the BP results, i.e., estimates for poterior marginals
postmargs_bp = mygraph.nodes(1).state;
priormargs_bp = mygraph.nodes(1).initstate;
for i=2:mygraph.N
    postmargs_bp(i) = [ mygraph.nodes(i).state ]; % take the state fields of the nodes array in an array of its own
    priormargs_bp(i) = [mygraph.nodes(i).initstate ];
end
% Compare the bp states with prior posterior marginals
% These should be the same for this example (since the bp iterations start

% Marginals of the model to compare with BP results
for l=1:length( V )
    pm( l ) = p_x.marginalise( [ (V(l)-1)*dims+1:V(l)*dims] );
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
    for i=1:length(V)
        pm( i ).draw( 'axis',gca,'dims',[1 2],'postcommands','hold on');
    end
    
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
        
        xy = graphj.nodes(i).initstate.states;
        l1 = plot( xy(1,:), xy(2,:), 'color',[0.5 0.5 0.5],'marker','s','linestyle','none','MarkerSize',2,'Linewidth',0.5 );
        
        
        xy = graphj.nodes(i).state.states;
        l2 = plot( xy(1,:), xy(2,:), 'color',col,'marker','x','linestyle','none','MarkerSize',8,'Linewidth',2 );
        
        
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
stpcnts = [1:length( DEBUG_PMRF_CARRAY)];
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
plot( stpcnts, log10(errn) )
axis([0, max(stpcnts), 0, 1.25*log10(max(errn))])
xlabel('iteration')
ylabel('log RSE')

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

