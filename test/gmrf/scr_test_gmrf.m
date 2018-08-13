% This script is to test the Gaussain Markov Random Field and Belief
% Propagation on an Undirected Network.

global DEBUG_GMRF DEBUG_GMRF_CARRAY DEBUG_VERBOSE
DEBUG_GMRF = 1;
DEBUG_VERBOSE = 1;

defaultGMRF;
defaultLikelihoods;

V = [1,2,3,4];
E = [[1 3];[2 3];[3 4];[3 1];[3 2];[4 3]];

dims = [1,1,1,1]'; % dimensionality of the variables associated with V

numsamples = 20; % 20 samples of measurement vectors will be generated.

p_x = gk( C_x, mu_x_1234 );

%% Find the edge potentials
epots = findedgepots( p_x, E, dims ); % Find edge potential functions given the whole model

x_samples = p_x.gensamples(numsamples);

p_n_1 = cpdf( gk( sigmasq_n1, mu_n1 ) );
p_n_2 = cpdf( gk( sigmasq_n2, mu_n2 ) );
p_n_3 = cpdf( gk( sigmasq_n3, mu_n3 ) );
p_n_4 = cpdf( gk( sigmasq_n4, mu_n4 ) );

p_n(1) = p_n_1;
p_n(2) = p_n_2;
p_n(3) = p_n_3;
p_n(4) = p_n_4;


n1_samples = p_n_1.gensamples(numsamples);
n2_samples = p_n_2.gensamples(numsamples);
n3_samples = p_n_3.gensamples(numsamples);
n4_samples = p_n_4.gensamples(numsamples);

y_samples = x_samples;

y_samples(1,:) =  n1_samples + x_samples(1,:);
y_samples(2,:) =  n2_samples + x_samples(2,:);
y_samples(3,:) =  n3_samples + x_samples(3,:);
y_samples(4,:) =  n4_samples + x_samples(4,:);

% Initial node states:
p1 = cpdf( gk( sigmasq_x_1, mu_x_1 ) );
p2 = cpdf( gk( sigmasq_x_2, mu_x_2 ) );
p3 = cpdf( gk( sigmasq_x_3, mu_x_3 ) );
p4 = cpdf( gk( sigmasq_x_4, mu_x_4 ) );
% Usually, we will not be given the global model but the edge potentials we assign edge potentials 


%% Find the mean and covariance of the joint distribution p(x,y)

sigma_ns = [ sigmasq_n1, sigmasq_n2, sigmasq_n3, sigmasq_n4]';


Lambda_xy = [ Lambda_x_1234 + diag( 1./sigma_ns ), -diag( 1./sigma_ns );...
    -diag( 1./sigma_ns ), diag( 1./sigma_ns )];

C_xy = Lambda_xy^(-1);

[C_xGy, mu_xGy, a_xGy, B_xGy ] = gausscond( C_xy, [5:8] , [mu_x_1234;zeros(4,1)], [0 0 0 0]' );

mygmrfcfg = gmrfcfg;
mygmrfcfg.V = V;
mygmrfcfg.E = E;
mygmrfcfg.mschedule = {[[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]]};

mynodecfg = nodecfg;
mynodecfg.state = p1;
mynodecfg.noisedist = p_n_1;
nodecfgs(1) = mynodecfg;

mynodecfg.state = p2;
mynodecfg.noisedist = p_n_2;
nodecfgs(2) = mynodecfg;

mynodecfg.state = p3;
mynodecfg.noisedist = p_n_3;
nodecfgs(3) = mynodecfg;

mynodecfg.state = p4;
mynodecfg.noisedist = p_n_4;
nodecfgs(4) = mynodecfg;

mygmrfcfg.nodes = nodecfgs;
mygmrfcfg.edgepotentials = epots;

mygraph = gmrf( mygmrfcfg );
%mygraph = mygraph.bp;

fhandle = figure;
fhandle2 = figure;


for stepcnt = 1:size( y_samples, 2 )
    
    % Get the measurements and compute the messages from the observed node
   
    y_vect = y_samples(:, stepcnt);
    x_vect = x_samples(:, stepcnt);
   
    mygraph.init2state; % Initialise the states of the nodes
    
    for i=1: length( mygraph.nodes )
       mynode = mygraph.nodes(i);
       mynode = mynode.recmeas( y_vect(i) ); %Find the myopic posterior and store under @node.state
 
       myopicpost(i) = mynode.getmyopicpost; % store the myopic posteriors
       
       mygraph.nodes(i) = mynode;
    end
    
    % Perform Belief Propagation
    mygraph = mygraph.bp;
    
    % Get the BP results, i.e., estimates for poterior marginals
    postmargs_bp = [ mygraph.nodes.state ]; % take the state fields of the nodes array in an array of its own 
   
    % Below, the centralised posteriors are found
    
    % Find the mean of the joint posterior
    mu_xGy = a_xGy + B_xGy*y_vect;
    % The covariance is irrespective of the value of y_vect
    % which is already stored in C_xy  
    % Find the posterior marginals
    for i=1:length( mygraph.nodes )
       % mvars = setdiff( [1:4],i); % marginal variables
        [C_p, mu_p ] = gaussmarg( C_xGy, i,  mu_xGy );
        postmargs_centralised(i) = cpdf( gk( C_p, mu_p ) );
    end
    
    % Plot the results with the algebraically found ones to compare
    xpnts = [-6:0.01:6];
    
    
    % 1-Compare the bp states with centralised posterior marginals
    % These should be the same for trees
    figure(  fhandle2 )
    clf;
    ax1 = subplot(411);
    hold on;
    grid on;
    % Plot the true value
    l1 = plot( [x_vect(1) x_vect(1)],[0 2], 'g' );
    % Plot the measurement
    l2 = plot( [y_vect(1) y_vect(1)],[0 2], 'm' );
    % Plot the posterior marginal
    ax2 = subplot(412);
     hold on;
    grid on;
    % Plot the true value
    l1 = plot( [x_vect(2) x_vect(2)],[0 2], 'g' );
    % Plot the measurement
    l2 = plot( [y_vect(2) y_vect(2)],[0 2], 'm' );
    % Plot the posterior marginal
    ax3 = subplot(413);
     hold on;
    grid on;
    % Plot the true value
    l1 = plot( [x_vect(3) x_vect(3)],[0 2], 'g' );
    % Plot the measurement
    l2 = plot( [y_vect(3) y_vect(3)],[0 2], 'm' );
    % Plot the posterior marginal
    ax4 = subplot(414);
     hold on;
    grid on;
    % Plot the true value
    l1 = plot( [x_vect(4) x_vect(4)],[0 2], 'g' );
    % Plot the measurement
    l2 = plot( [y_vect(4) y_vect(4)],[0 2], 'm' );
    % Plot the posterior marginal
   
    % Plot the bp posterior marginals
    [ahandle, fighandle, lpm_bp] = postmargs_bp.draw('axis', [ax1,ax2,ax3,ax4], 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
    % Plot the centralised posterior marginals
    [ahandle, fighandle, lpm_cent] = postmargs_centralised.draw('axis', [ax1,ax2,ax3,ax4], 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    % Put down the legend
    axis(ax1);
    legend( [lpm_bp(1) lpm_cent(1), ], 'post. marg. bp', 'post. marg. cent.' );
   
    
    %% Plot, now, the priors, myopic, bp and centralised posteriors
    figure(  fhandle )
    clf;
    subplot(411)
    hold on
    grid on
    % Plot the true value
    l1 = plot( [x_vect(1) x_vect(1)],[0 2], 'g' );
    % Plot the measurement
    l2 = plot( [y_vect(1) y_vect(1)],[0 2], 'm' );
    % Plot the posterior marginal
    [ahandle, fighandle, lmp] = myopicpost(1).draw('axis', gca, 'eval', xpnts, 'options',  '''c'',''LineStyle'',''-''' );
    
    [ahandle, fighandle, lpost_cent] = postmargs_centralised(1).draw('axis', gca, 'eval', xpnts, 'options',  '''m'',''LineStyle'',''-''' );
    [ahandle, fighandle, lpost_bp] = postmargs_bp(1).draw('axis', gca, 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
   
    % Plot the initial state
    [ahandle, fighandle, lprior] = mygraph.nodes(1).initstate.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    
    legend([l1,l2,lprior,lmp,lpost_bp,lpost_cent],'X','Y','prior','post. marg. myopic', 'post. marg. bp','post. marg. cent.')
        
    subplot(412)
    hold on
    grid on
    l1 = plot( [x_vect(2) x_vect(2)],[0 2], 'g' );
    l2 = plot( [y_vect(2) y_vect(2)],[0 2], 'm' );
    [ahandle, fighandle, lmp] = myopicpost(2).draw('axis', gca, 'eval', xpnts, 'options',  '''c'',''LineStyle'',''-''' );
    
    [ahandle, fighandle, lpost_cent] = postmargs_centralised(2).draw('axis', gca, 'eval', xpnts, 'options',  '''m'',''LineStyle'',''-''' );
  [ahandle, fighandle, lpost_bp] = postmargs_bp(2).draw('axis', gca, 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
    
    % Plot the initial state
    [ahandle, fighandle, lprior] = mygraph.nodes(2).initstate.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    
    subplot(413)
    hold on
    grid on
    l1 = plot( [x_vect(3) x_vect(3)],[0 2], 'g' );
    l2 = plot( [y_vect(3) y_vect(3)],[0 2], 'm' );
    [ahandle, fighandle, lmp] = myopicpost(3).draw('axis', gca, 'eval', xpnts, 'options',  '''c'',''LineStyle'',''-''' );
    
    [ahandle, fighandle, lpost_cent] = postmargs_centralised(3).draw('axis', gca, 'eval', xpnts, 'options',  '''m'',''LineStyle'',''-''' );
    [ahandle, fighandle, lpost_bp] = postmargs_bp(3).draw('axis', gca, 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
 % Plot the initial state
    [ahandle, fighandle, lprior] = mygraph.nodes(3).initstate.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    
    subplot(414)
    hold on
    grid on
    l1 = plot( [x_vect(4) x_vect(4)],[0 2], 'g' );
    l2 = plot( [y_vect(4) y_vect(4)],[0 2], 'm' );
    [ahandle, fighandle, lmp] = myopicpost(4).draw('axis', gca, 'eval', xpnts, 'options',  '''c'',''LineStyle'',''-''' );
    
    
    [ahandle, fighandle, lpost_cent] = postmargs_centralised(4).draw('axis', gca, 'eval', xpnts, 'options',  '''m'',''LineStyle'',''-''' );
    [ahandle, fighandle, lpost_bp] = postmargs_bp(4).draw('axis', gca, 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
    % Plot the initial state
    [ahandle, fighandle, lprior] = mygraph.nodes(4).initstate.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    
    drawnow;
    pause(0.5);
end
    

