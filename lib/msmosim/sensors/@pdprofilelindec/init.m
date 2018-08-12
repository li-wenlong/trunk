function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'pdprofilelindeccfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'pdprofilelindeccfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.threshold = cfg.threshold; % range threshold beyond which a constant pd is used.
this.range = cfg.range;
this.pdfar = cfg.pdfar;

% find 

% Find a and b of the linear decay (-ar+b) using the boundary
% conditions 
% pdfar =  -a T + b  (1) and 
% pdatzero = b (2)

T = this.threshold;

this.b = cfg.pdatzero;
this.a = ( this.b - this.pdfar )/T;

this.pdnear = ( -this.a*this.range^2/2 + this.b*this.range )/this.range ;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


