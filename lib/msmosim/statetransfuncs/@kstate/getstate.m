function out = getstate( this, varargin )


if nargin>=2
    labels = varargin{1};
    out = this.catstate(labels); 
else
    out = this.state;
end