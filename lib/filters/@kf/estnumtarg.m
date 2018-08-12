function [postcardmaxs, varargout] = estnumtarg( this )
% [maxcard, meancard] = estnumtarg
postcardmaxs = length( this.post );
postcardmeans = length( this.post );

if nargout>=2
    varargout{1} = postcardmeans;
end
