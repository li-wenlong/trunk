function pimix = getperspostintensity(this)
% GETPERSPOSTINTENSITY returns the persistent particles representing the posterior intensity.
%

% Pull the index of the persistent particles
indx1 = this.postintensity.getindx( 'p' );

pimix = this.postintensity(indx1);

% Also prune the small clusters and choose measurement labeled ones
pimix = pimix.prune;
