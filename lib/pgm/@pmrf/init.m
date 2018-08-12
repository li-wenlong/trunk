function varargout = init( this, varargin )

global DEBUG_PMRF DEBUG_VERBOSE

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'pmrfcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'pmrfcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end
if DEBUG_PMRF
    disp('inside @pmrf.init')
end
% Here perform the assignments
this.V = unique( cfg.V(:),'legacy' );

% Verify that the edge set satisfies undirectedness,
% i.e., for every (i,j) in E, (j,i) is in E:
[iu, ei ] = isundirected( cfg.E );
if iu == 0
    % Edge set is not undirected
    warning(sprintf('Edge set is not undirected, i.e., the following (i,j), do not have their reverse (j,i) in E:%d,', ei));
end

this.E = cfg.E;

if isempty( cfg.mschedule)
    this.mschedule = scheduler('pattern', {this.E} );
else
    this.mschedule = scheduler('pattern', cfg.mschedule );
end

if isempty( cfg.uschedule)
    this.uschedule = scheduler('pattern', {this.V} );
else
    this.uschedule = scheduler('pattern', cfg.uschedule );
end

if isempty( cfg.euschedule )
    this.euschedule = scheduler([]);
else
    this.euschedule = scheduler( 'pattern', cfg.euschedule  );
end


this.iternum = 0; % initial state for the iteration count iternum
if isempty( cfg.itermax)
    % Default maximum number of iterations if not specified
    this.itermax = this.mschedule.getpatlen;
else
    this.itermax = cfg.itermax;
end

this.N = size( this.V, 1 );
this.M = size( this.E, 1 );

% Create edge potential objects
if strcmp( class( this.cfg.edgepots(1) ) ,'edgepotcfg' )
    this.edgepots = edgepot([]);
    for l=1:this.M
        myedgepotcfg = this.cfg.edgepots(l);
        myedgepotcfg.e = this.E( l,: ); % The ids are assigned in the order stored in E
        this.edgepots(l) = edgepot( myedgepotcfg );
    end
elseif strcmp( class( this.cfg.edgepots(1)),'quadsinglegausscfg' )
    this.edgepots = quadsinglegauss([]);
    for l=1:this.M
        myedgepotcfg = this.cfg.edgepots(l);
        myedgepotcfg.e = this.E( l,: ); % The ids are assigned in the order stored in E
        this.edgepots(l) = quadsinglegauss( myedgepotcfg );
    end
elseif strcmp( class( this.cfg.edgepots(1)),'quadmultigausscfg' )
    this.edgepots = quadmultigauss([]);
    for l=1:this.M
        myedgepotcfg = this.cfg.edgepots(l);
        myedgepotcfg.e = this.E( l,: ); % The ids are assigned in the order stored in E
        this.edgepots(l) = quadmultigauss( myedgepotcfg );
    end
elseif strcmp( class( this.cfg.edgepots(1)),'dualgmmphdcfg' )
     this.edgepots = dualgmmphd([]);
    for l=1:this.M
        myedgepotcfg = this.cfg.edgepots(l);
        myedgepotcfg.e = this.E( l,: ); % The ids are assigned in the order stored in E
        this.edgepots(l) = dualgmmphd( myedgepotcfg );
    end
    
else
    
    error('Unsupported configuration class %s ', class( this.cfg.edgepots(1)) );
end
    

% Create the node objects
for i=1:this.N 
    mynodecfg = this.cfg.nodes(i); % Get node configuration object
    mynodecfg.id = this.V(i); % The ids are assigned as sotred in V, overrides the configuration
    
    % Find the children
    [chi_, edges2chi ] = chi( this.E, mynodecfg.id );
    mynodecfg.children = chi_;
    
    pa_ = pa( this.E, mynodecfg.id );
    mynodecfg.parents = pa( this.E, mynodecfg.id );

    nei_ = nei( this.E, mynodecfg.id );
    mynodecfg.neighbours = nei_;
    
    mynodecfg.iternum = this.iternum;
    
    if isa( mynodecfg,'nodecfg'  )
        nodeobj = node( mynodecfg );
    elseif isa( mynodecfg,'pbnodecfg' )
        nodeobj = pbnode( mynodecfg );
    end
    
    % Assign the edgepotential objects to this node
    nodeobj.recedgepotential( chi_ , this.edgepots( edges2chi ) );
    
    if isempty( this.nodes )
        this.nodes = nodeobj;
    else
        this.nodes(i) = nodeobj;
    end
    this.dims(i) = nodeobj.getstatedim;
end

% If no configuration was provided for nodes
% the corresponding field is an empty array of trpe pbnode
if isempty( this.nodes )
    this.nodes = pbnode( [] );
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
