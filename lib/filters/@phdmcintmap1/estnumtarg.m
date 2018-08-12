function [postcardmaxs, varargout] = estnumtarg( this )
% [maxcard, meancard] = estnumtarg
postcardmaxs = [];
postcardmeans = [];
    
if ~isempty( this.postcardbuffer )
    numsteps = length( this.postcardbuffer );
    
    
    detmaxs = [];
    undetmaxs = [];
    persmaxs = [];
    for j=1:numsteps
      [maxval, ind ] = max( this.postcardbuffer{j} );
      postcardmaxs(j) = ind - 1;
      postcardmeans(j)  = sum( this.postcardbuffer{j}.*[0:length(this.postcardbuffer{j})-1]' );
    end      
end    



if nargout>=2
    varargout{1} = postcardmeans;
end
