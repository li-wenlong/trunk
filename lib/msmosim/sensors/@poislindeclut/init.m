function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'poislindeclutcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'poislindeclutcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

% Find intatzero

this.threshold = cfg.threshold; % range threshold beyond which a uniform distr. is used.
this.range = cfg.range;
% Find I', intensity at the uniform region, intun
this.lambdaou = cfg.lambdaou;
this.intun = cfg.lambdaou/( pi*abs(this.range^2 - this.threshold^2 ) );        % Intensity over the uniform region


% Find a and b of the log linear decay exp(-ar+b) using the boundary
% condition I' = exp(-a T + b) and the integral under the curve being equal
% to lambdod;
this.lambdaod = cfg.lambdaod;

T = this.threshold;
Iprime = this.intun;

a = ( -Iprime*T^2/2 + this.lambdaod/(2*pi) )*6/T^3;
b = Iprime + a*T;

this.a = a;
this.b = b;
this.intatzero = b;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


