function [ comps ] = gencompindx( gmm_, varargin )

numsamples = 1;
if nargin>=2
    numsamples = varargin{1}(1);
end
numcomps = getnumcomp( gmm_ );
dim = getdims(gmm_);
x = zeros(dim,numsamples);

comps = randint( gmm_.w, numsamples );