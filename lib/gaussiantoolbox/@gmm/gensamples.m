function [x, varargout] = gensamples( gmm_, varargin )
% 
%

numsamples = 1;
if nargin>=2
    numsamples = varargin{1}(1);
end
numcomps = getnumcomp( gmm_ );
dim = getdims(gmm_);
x = zeros(dim,numsamples);

comps = randint( gmm_.w, numsamples );
for i=1:numcomps
    ind = find(comps == i);
    if ~isempty(ind)
       x(:,ind) = gensamples(gmm_.pdfs(i), length(ind) );
    end
end
if nargout>=2
    varargout{1} = comps;
end


    
