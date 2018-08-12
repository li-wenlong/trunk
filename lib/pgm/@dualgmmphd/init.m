function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'dualgmmphdcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'dualgmmphdcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

%% Below is a copy paste from @edgepot.init - could not inheret it with the 
%% @edgepotcfg part of quadsinglegausscfg

% Here, perform the assignments
this.e = cfg.e;                 % (i,j) pair of the edge as its identifier
this.sourceid = this.e(1);      % id of the source node over this (directed) edge
this.sinkid = this.e(2);        % id of the sink node over this edge
this.thetas = cfg.thetas;       % points to evaluate this edge at
this.numthetas = cfg.numthetas;
this.dim    = cfg.dim;
this.labels = cfg.labels;
this.limits = cfg.limits;
this.initgenfun = cfg.initgenfun;
this.psis = cfg.psis;           % log edge potential evaluated at \theta_i stored in edgepot.thetas
this.logpsis = cfg.logpsis;     % the edge potential evaluations \psi( \theta_i ) 
this.potfun = cfg.potfun;       % This is the function that will be called to sample from the edge potential
this.potobj = cfg.potobj;       % This is the @gk or @particles object that facilitates a Kernel sum 
        % (as a KDE) to evalute the potential function given (epoints, sigmae) pairs
this.updatefun = cfg.updatefun; % This is the function to update the edge potential by evaluating it at a possibly
                   % new set of thetas
                   
if ~isempty( cfg.updateparams )
    this.updateparams = scheduler('pattern', cfg.updateparams); % FIFO container buffer for passing parameters to update   
end

%% Below are for the fields extending @edgepot
%% Note that some of these will be delted from the stored configuration once copied.
this.T = this.cfg.T; % time axis for the containers below

this.predis = this.cfg.predis;
this.cfg.predis = this.cfg.predis([]);% prediction disttributions of node i

this.predjs = this.cfg.predjs; % prediction distributions of node j
this.cfg.predjs =  this.cfg.predjs([]);

if isa(  this.cfg.filteri , 'phdgmabcfg' )
    this.filteri = phdgmab( this.cfg.filteri );
else
    error('%s object in the configration, was exdpecting phdgmabcfg',class(this.cfg.filteri) );
end

if isa( this.cfg.filterj, 'phdgmabcfg' )
    this.filterj = phdgmab( this.cfg.filterj );
else
    error('%s object in the configration, was exdpecting phdgmabcfg',class(this.cfg.filterj) );
end

this.sensori = linobs( this.cfg.sensoricfg  ); % sensor object encapsulating H_i and R_i of the linear observation model
this.sensori.insensorframe = 1;

this.sensorj = linobs( this.cfg.sensorjcfg  );
this.sensorj.insensorframe = 1;

this.sensorbufferi = this.cfg.sensorbufferi;
this.cfg.sensorbufferi = this.cfg.sensorbufferi([]);

this.sensorbufferj = this.cfg.sensorbufferj; % sensor j's measurement buffer
this.cfg.sensorbufferj =  this.cfg.sensorbufferj([]);


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
