function s = getstate(this, varargin )

if nargin>=2
    labels = varargin{1};
    k = this.stfobjs{this.crrntstfnum}.getkstate;
    s = k.catstate(labels); 
else
    s = this.stfobjs{this.crrntstfnum}.state;
end