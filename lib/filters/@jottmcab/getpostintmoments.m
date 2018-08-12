function pimix = getpostintmoments(this)
% GETPOSTINTMOMENTS returns the Gaussian Mixture of the persistent
% particles representing the posterior intensity
%


% Pull the index of the persistent particles
indx1 = this.postintensity.getindx( 'p' );

if isempty( indx1 )
    pimix = [];
else
    pimix = this.postintensity(indx1).par2gmm;
end
