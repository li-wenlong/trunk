function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'sensorcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'sensorcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.time = cfg.inittime;
this.location = cfg.location;
this.orientation = cfg.orientation;
this.velearth = cfg.velearth;
this.detonlynear = cfg.detonlynear;
this.srcbuffer = {};% source buffer
this.srbuffer = {} ;% Sensor report buffer

if isa( cfg.cluttercfg, 'poisclut1cfg' )
   this.clutter = poisclut1(cfg.cluttercfg );
elseif isa( cfg.cluttercfg, 'noclutcfg' )
    this.clutter = noclut;
else 
error('Unknown clutter class')
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


