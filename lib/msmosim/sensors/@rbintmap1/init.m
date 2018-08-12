function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'rbintmap1cfg' )
        error('Unknown configuration object!');
    end
else
    if ~isa( this.cfg, 'rbintmap1cfg' )
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

this.minrange = cfg.minrange; % The four parameters specifying the field of fiew
this.maxrange = cfg.maxrange;
this.minalpha = cfg.minalpha;
this.maxalpha = cfg.maxalpha;
this.dwelltime = cfg.dwelltime;
this.betasquare = cfg.betasquare;
this.signalpower = cfg.signalpower;
this.deltarange = cfg.deltarange;
this.deltabearing = cfg.deltabearing;
this.numcols = round( (this.maxalpha - this.minalpha )/this.deltabearing );
this.numrows = round( (this.maxrange - this.minrange )/this.deltarange );
this.colcentres = ([this.numcols:-1:1]-1)*this.deltabearing + this.minalpha + this.deltabearing/2;
this.rowcentres = ([1:this.numrows]-1)*this.deltarange + this.minrange + this.deltarange/2;
 
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


