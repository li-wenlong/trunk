function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'extsensorcfg' )
        error('Unknown configuration object!');
    end
else
    if ~isa( this.cfg, 'extsensorcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end


this.time = cfg.inittime;
this.location = cfg.location(:);
this.orientation = cfg.orientation(:);
this.velearth = cfg.velearth(:);
this.srcbuffer = {};% source buffer
this.srbuffer = {} ;% Sensor report buffer

this.pd = cfg.pd;
this.maxrange = cfg.maxrange;
this.alpha = cfg.alpha;
this.stdang = cfg.stdang;
this.stdrange = cfg.stdrange;

this.m = cfg.m;
this.P = cfg.P;
this.x_min = cfg.x_min;
this.x_max = cfg.x_max;
this.y_min = cfg.y_min;
this.y_max = cfg.y_max;
this.lambda = cfg.lambda;
this.gamma = cfg.gamma;
this.angle = cfg.angle;
this.major_axis = cfg.major_axis;
this.minor_axis = cfg.minor_axis;
this.r_sig1 = cfg.r_sig1;


if isa( cfg.cluttercfg, 'noclutcfg' )
    this.clutter = noclut;
elseif isa( cfg.cluttercfg, 'poisclut1cfg' )
    this.clutter = poisclut1(cfg.cluttercfg );
elseif isa( cfg.cluttercfg, 'poisclut2cfg' )
    cfg.cluttercfg.range = cfg.maxrange;
    cfg.cluttercfg.alpha = cfg.alpha;
    this.clutter = poisclut2(cfg.cluttercfg );    
else
error('Unknown clutter class')
end

this.cfg = cfg;
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


