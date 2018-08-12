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

numbins = 10;

mu1 = 5;
var1 = 2;
mu2 = 5;
var2 = 2;

zest = 0.85;
omegaval = 0.5;

card1 = rand(numbins+1,1)*sqrt( var1.^2 )/2;
card2 = rand(numbins+1,1)*sqrt( var2.^2 )/2;


card1(mu1+1) = sum(card1);
card2(mu2+1) = sum(card2);

card1 = card1/sum(card1);
card2 = card2/sum(card2);

card1 = binopdf( [0:numbins], mu1, 0.9 )';
card2 = binopdf( [0:numbins], mu2, 0.85 )';

minseries = min( card1, card2 );
expseries = ( card1.^(1-omegaval) ).*( card2.^omegaval );

ns = [0:numbins]';

zomegan = ( zest.^ns );

fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
Nomega = sum(fusedcard);
fusedcard =  fusedcard/Nomega;

bndratio = minseries./expseries;
bndratio( isnan( bndratio ) ) = 1;

incbound = ( Nomega*bndratio ).^(1./ns) ;% Inconsistency bound


figure
plot( ns, incbound )
hold on
plot( ns, zest*ones(size(ns)), 'r' )

figure
grid on 
hold on
plot( ns, card1 )
plot( ns, card2, 'r' )
plot( ns, fusedcard, 'g' )
legend( 'p_1','p_2','p_\omega')