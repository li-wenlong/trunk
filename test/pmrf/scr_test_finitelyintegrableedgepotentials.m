
% This script shows that the p(x_s, x_t)/p(x_s)p(x_t) ratio as an edge
% potential of a Gaussian tree MRF satisfies the finite
% integrability condition and allows for sample-based representations.
% This ows to having always lighter tails in the numerator.
xvals  = [-20:0.01:20];

defaultGMRF;
defaultLikelihoods;

V = [1,2,3,4];
E = [[1 3];[2 3];[3 4];[3 1];[3 2];[4 3]];
dims = [1,1,1,1]';


numsamples = 300;
p_x = gk( C_x, mu_x_1234 );

%% Find the edge potentials
% Get the joint and marginal distributions to evaluate 
% \psi(x_i,x_j) = p(x_i,x_j)/(p(x_i)p(x_j))
epotobjs = getpwpotparams( p_x, E, dims ); % Find

% Take, for example, the potential on the first edge
m = epotobjs{1};

% find the conditional dist
[cm, mm] = gausscond( m.jointdist.C, 1, m.jointdist.m, m.localmarg.m );

cd = cpdf( gk(cm,mm) );

e1 = cd.evaluate(xvals);
e2 = m.neimarg.evaluate(xvals);

figure
plot(xvals, e1./e2 )

% The above is the numeric, below is the analytic

pratio = ( cd/m.neimarg );
e3 = pratio.evaluate(xvals);
hold on
plot( xvals, e3, '--r')
legend('numeric','analytic')