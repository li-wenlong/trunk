function [maxsigma, varargout] = getmaxsigma( par )

numparticles = par.numparticles;

maxsigma = 0;
maxind = 0;
for i=1:numparticles
    sigmasqs = sort( diag( par.C(:,:, i) ),'descend' );
    
    inds = find( sigmasqs>=maxsigma );
    if ~isempty( inds )
        maxsigma = sigmasqs( inds(1) );
        maxind = i;
    end
end

if nargout>=2
    varargout{1} = maxind;
end