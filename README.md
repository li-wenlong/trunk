# trunk
MATLAB libraries for simulation of sensor data, filtering, fusion and inference algorithms together with test scripts. The Algorithms implemented here cover from inference on Markov chains (particle filters, Kalman filters), Markov chains with population distributions (PHD, CPHD filters), belief propagation on pairwise Markov random fields (Gaussian and particle versions) and separable likelihoods for parameter estimation in multi-sensor Markov chains.

/lib contains the library directories
/test contains the test directories for individual modules
/various contains various functions and scripts
/utils are utility classes to represent population distributions etc.
/extlibs are external libraries (e.g., OSPA set distance and similar)

The library content is as follows:

/lib/pgm contains the pairwise markov random field and separable likelihood libraries used in 
Uney, Mulgrew, Clark "Latent parameter estimation in fusion networks using separable likelihoods" IEEE TSIPN 2018
Uney, Mulgrew, Clark "A cooperative approach to sensor localisation in distributed fusion networks" IEEE TSP 2016
Uney, Mulgrew, Clark "Latent parameter estimation in fusion networks using separable likelihoods" IEEE ICASSP 2016
@gmrf: Markov random field library for Gaussian belief propagation (uses @edgepot edgepotential library and @node Gaussian node classes)
@pmrf: Markov random field library for particle belief propagation (uses @edgepot and particle belief node @pbnode classes)
@quadmultigauss: Quad-term separable likelihood library used in the TSIPN 2018 article.
@quadsinglegauss: Quad-term separable likelihood library used in the ICASSP 2016 article.
@dualgmmphd: Single-term separable likelihood library - Gaussian mixture PHD filter version of the TSP 2016 article stuff.

/lib/filters contains Bayesian recursive filters on Markov chains with single and multi-object (population) distributions including Kalman filter ( @kf), particle filter (@pf), Bernoulli filter (@jottmcab, @berintmap1 for filtering EO sensor data), PHD filters (Gaussian mixture/adaptive birth @phdgmab and particle @phdmcab versions and @phdmcintmap1 for filtering EO sensor data), CPHD filters (@cpmdmcab and second order statistics version @cphdmcvar usied in our TSP 2014 article), 

/lib/gaussiantoolbox contains Gaussian kernel class @gk to do algebra and marginalisation with Gaussian kernels/distribution together with @gmm class for representation and manipulation on Gaussian mixtures and Gaussian kernel sum class @gksum 

/lib/particletoolbox contains the particle class @particles

/lib/msmosim contains the multi-sensor multi-object simulator class @msmosim which uses platform class @platform
/lib/msmosim/sensors contains sensor classes
/lib/msmosim/statetransfucs contains state transition functions
/lib/cfg contains default configurations of all classes
