function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'pbnodecfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'pbnodecfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

% Here perform the assignments
this.id = cfg.id;
this.parents = cfg.parents;
this.children = cfg.children;
this.iternum = cfg.iternum;
this.state = cfg.state;

if ~isempty( this.state )
    if isa( this.state, 'particles')
        this.dim = this.state.getstatedims;
    else 
        this.dim = 0;
    end
else
    this.dim = 0;
end

this.initstate = cfg.state; % obsolete field
this.edgepotentials = edgepot( [] );
for k=1:length( cfg.edgepotentials)
    this.edgepotentials{k} = edgepot( cfg.edgepotentials(k) );
end
this.epotobjs = cfg.epotobjs;
this.inboxlog = zeros(1, length(this.parents) );

dummy = particles;
this.inbox = {};
this.previnboxlog = this.inboxlog;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
