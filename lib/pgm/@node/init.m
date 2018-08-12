function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'nodecfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'nodecfg' )
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

if isa( this.state, 'gk' )
    this.dim = this.state.getdims;
elseif isa( this.state, 'particles' )
    this.dim = this.state.getstatedims;
else
    this.dim = 0;
end

this.initstate = cfg.state; % obsolete field
this.noisedist = cfg.noisedist;
this.edgepotentials = cfg.edgepotentials;
this.epotobjs = cfg.epotobjs;
this.inboxlog = zeros(1, length(this.parents) );

if isa( this.state, 'gk' )
    dummy = gk;
elseif isa( this.state, 'particles' )
    dummy = kde;
else
    dummy = [1];
end

this.inbox = dummy( [] );
this.previnboxlog = this.inboxlog;

if isempty( cfg.C )
    this.C = eye(this.dim);
else
    this.C = cfg.C;
end

this.ydim = size(this.C, 1);
this.y = ones( this.ydim, 1);
this.y = this.y([]);

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
