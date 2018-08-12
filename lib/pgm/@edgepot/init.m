function varargout = init( this, varargin )
% initiates an edgepot object

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'edgepotcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'edgepotcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

% Here, perform the assignments
this.e = cfg.e;                 % (i,j) pair of the edge as its identifier
this.sourceid = this.e(1);      % id of the source node over this (directed) edge
this.sinkid = this.e(2);        % id of the sink node over this edge
this.thetas = cfg.thetas;       % points to evaluate this edge
this.numthetas = cfg.numthetas; % number of these points
this.dim    = cfg.dim;          % dimensionality of thetas
this.labels = cfg.labels;       % the labels of these dimensions
this.limits = cfg.limits;       % the limits along these axis
this.initgenfun = cfg.initgenfun;% function to generate initial values of thetas
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


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
