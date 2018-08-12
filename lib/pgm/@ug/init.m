function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'ugcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'ugcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end
% Here perform the assignments
this.V = unique( cfg.V(:),'legacy' );
this.E = cfg.E;

this.nodes = node([]);
this.edgepots = edgepot([]);
this.N = size( this.V, 1 );
this.M = size( this.E, 1 );
% Create the node objects
for i=1:this.N
    mynodecfg = nodecfg; % Get node configuration object
    mynodecfg.id = this.V(i);
    
    % Find the children
    [chi_, es] = chi( this.E, mynodecfg.id );
    mynodecfg.children = chi_;
    
    pa_ = pa( this.E, mynodecfg.id );
    mynodecfg.parents = pa( this.E, mynodecfg.id );

    nei_ = nei( this.E, mynodecfg.id );
    mynodecfg.neighbours = nei_;
       
    nodeobj = node( mynodecfg );
    this.nodes(i) = nodeobj;
end
% Create the edge potential objects
for i=1:this.N
    myedgecfg = edgepotcfg;
    myedgecfg.e = this.E(i,:);
    
    edgepotobj = edgepot( myedgecfg );
    this.edgepots(i) = edgepotobj;
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
