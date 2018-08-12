% This script is to demonstrate a short coming of EMD rule for Poisson
% processes regarding the fused cardinality. 
% The z value as the integration \int s_1^(1-\omega) s_2^omega 
% is typically less than one. This can be intuitively found by considering
% s_1 and s_2 as two Gaussians.
% Then, the mean parameter of the fused cardinality distribution is
% typically less than mu_1^(1-\omega)*mu_2^(omega)
% For example, when mu_1= mu_2 and \omega = 0.5, if zest = 0.5, the fused
% cardinality will estimate the number of targets as half the target number
% estimate of the individual Poisson processes.
% Such cases are very very rarely encountered for general cardinality
% distributions of the iid cluster processes.

numbins = 1000;

mu1 = 200;
mu2 = 220;

zest = 0.5;
omegaval = 0.75;


card1 = poisspdf( [0:numbins], mu1 )';
card2 = poisspdf( [0:numbins], mu2 )';

ns = [0:numbins]';

fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*( zest.^ns );
fusedcard =  fusedcard/sum(fusedcard);

figure
grid on 
hold on
plot( card1 )
plot( card2, 'r' )
plot( fusedcard, 'g' )
legend( 'p_1','p_2','p_\omega')