% This script is to test the Continuous Markov Random Field class pmrf
% and Belief Propagation on an Undirected Network.

% The test example is Guassian and also used to test the Gaussiam MRF class
% gmrf in scr_test_gmrf.m

global DEBUG_PMRF DEBUG_PMRF_CARRAY DEBUG_VERBOSE
DEBUG_PMRF = 1;
DEBUG_VERBOSE = 1;

defaultGMRF;
defaultLikelihoods;

V = [1,2,3,4];
E = [[1 3];[2 3];[3 4];[3 1];[3 2];[4 3]];
dims = [1,1,1,1]';


numsamples = 1000;
p_x = gk( C_x, mu_x_1234 );

%% Find the edge potentials
% Get the joint and marginal distributions to evaluate 
% \psi(x_i,x_j) = p(x_i,x_j)/(p(x_i)p(x_j))
epotobjs = getpwpotparams( p_x, E, dims ); % Find edge potential functions given the whole model
% Now, the function pointers to evaluate \psi(x_i,x_j)s
numedges = size( E,1);
for l=1:numedges
    epotfuncts{l} = @pwpotsampler;
end

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
%% Find the joint conditional x|y
[C_xGy, mu_xGy, a_xGy, B_xGy ] = gausscond( C_xy, [5:8] , [mu_x_1234;zeros(4,1)], [0 0 0 0]' );

%% Particle represented PMRF configuration
mypmrfcfg = pmrfcfg;
mypmrfcfg.V = V;
mypmrfcfg.E = E;
mypmrfcfg.mschedule = {[[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]]};
% mypmrfcfg.mschedule = {[[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]],...
%     [[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]],...
%     [[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]],...
%     [[1 3];[2 3];[4 3];[3 1];[3 2];[3 4]]};
mypmrfcfg.epotobjs = epotobjs;
mypmrfcfg.edgepotentials = epotfuncts;

mynodecfg = nodecfg;
mynodecfg.state = particles('states', p1.gensamples(numsamples),'labels',1);
mynodecfg.state = mynodecfg.state.findkdebws;
mynodecfg.noisedist = p_n_1;
nodecfgs(1) = mynodecfg;

mynodecfg.state = particles('states', p2.gensamples(numsamples),'labels',2);
mynodecfg.state = mynodecfg.state.findkdebws;
mynodecfg.noisedist = p_n_2;
nodecfgs(2) = mynodecfg;

mynodecfg.state = particles('states', p3.gensamples(numsamples),'labels',3);
mynodecfg.state = mynodecfg.state.findkdebws;
mynodecfg.noisedist = p_n_3;
nodecfgs(3) = mynodecfg;

mynodecfg.state = particles('states', p4.gensamples(numsamples),'labels',4);
mynodecfg.state = mynodecfg.state.findkdebws;
mynodecfg.noisedist = p_n_4;
nodecfgs(4) = mynodecfg;

mypmrfcfg.nodes = nodecfgs;

mygraph = pmrf( mypmrfcfg );
mygraph = mygraph.bp;


% Get the BP results, i.e., estimates for poterior marginals
postmargs_bp = mygraph.nodes(1).state;
priormargs_bp = mygraph.nodes(1).initstate;
for i=2:mygraph.N
    postmargs_bp(i) = [ mygraph.nodes(i).state ]; % take the state fields of the nodes array in an array of its own
    priormargs_bp(i) = [mygraph.nodes(i).initstate ];
end
% Compare the bp states with prior posterior marginals
% These should be the same for this example (since the bp iterations start
% at the fixed points).
xpnts = [-6:0.01:6];
figure
clf;
ax1 = subplot(411);
hold on;
grid on;
[ahandle, fighandle, lprior1] = p1.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
   
ax2 = subplot(412);
hold on;
grid on;
[ahandle, fighandle, lprior] = p2.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
   
 
ax3 = subplot(413);
hold on;
grid on;
[ahandle, fighandle, lprior] = p3.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );


ax4 = subplot(414);
hold on;
grid on;
[ahandle, fighandle, lprior] = p4.draw('axis', gca, 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );

% Plot the true value
% Plot the bp posterior marginals
[ahandle, fighandle, lpm_bp] = postmargs_bp.draw('axis', [ax1,ax2,ax3,ax4], 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
% Plot the centralised posterior marginals
[ahandle, fighandle, lppstm_bp] = priormargs_bp.draw('axis', [ax1,ax2,ax3,ax4], 'eval', xpnts, 'options',  '''g'',''LineStyle'',''-''' );
axis(ax1);
legend( [lprior,lpm_bp(1) lppstm_bp(1), ], 'prior marg.','post. marg. bp', 'kde prior marg. to bp' );
