function par = gmm2particles(this, varargin )

numsamples = 1000;
if nargin>=2
    numsamples = varargin{1}(1);
end

[states, labels] = this.gensamples( numsamples );

par = particles('states', states, 'labels', labels(:) );


