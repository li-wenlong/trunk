function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'gmrfcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'gmrfcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end
disp('inside @gmrf.init')
% Here perform the assignments
this.V = unique( cfg.V(:), 'legacy' );
this.E = cfg.E;
if isempty( cfg.mschedule)
    this.mschedule = scheduler('pattern', {this.E} );
else
    this.mschedule = scheduler('pattern', cfg.mschedule );
end
this.nodes = node([]);
this.N = size( this.V, 1 );
this.M = size( this.E, 1 );
% Create the node objects
for i=1:this.N 
    mynodecfg = this.cfg.nodes(i); % Get node configuration object
    mynodecfg.id = this.V(i);
    
    % Find the children
    [chi_, e] = chi( this.E, mynodecfg.id );
    mynodecfg.children = chi_;
    mynodecfg.edgepotentials = this.cfg.edgepotentials(e);
    
    pa_ = pa( this.E, mynodecfg.id );
    mynodecfg.parents = pa( this.E, mynodecfg.id );

    nei_ = nei( this.E, mynodecfg.id );
    mynodecfg.neighbours = nei_;
    
    mynodecfg.iternum = this.iternum;
    
    nodeobj = node( mynodecfg );
    this.nodes(i) = nodeobj;
    this.dims(i) = nodeobj.getstatedim;
end

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
