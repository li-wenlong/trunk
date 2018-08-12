function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'rbsensor2cfg' )
        error('Unknown configuration object!');
    end
else
    if ~isa( this.cfg, 'rbsensor2cfg' )
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

if isa( cfg.cluttercfg, 'noclutcfg' )
    this.clutter = noclut;
elseif isa( cfg.cluttercfg, 'poisclut1cfg' )
    this.clutter = poisclut1(cfg.cluttercfg );
elseif isa( cfg.cluttercfg, 'poisclut2cfg' )
    cfg.cluttercfg.range = cfg.maxrange;
    cfg.cluttercfg.alpha = cfg.alpha;
    this.clutter = poisclut2(cfg.cluttercfg );    
elseif isa( cfg.cluttercfg, 'poislldclutcfg' )
    cfg.cluttercfg.range = cfg.maxrange;
  %  cfg.cluttercfg.alpha = cfg.alpha;
    this.clutter = poislldclut(cfg.cluttercfg );    
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


