function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'eobinomclutcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'eobinomclutcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.n = cfg.n;
this.p = cfg.p;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


