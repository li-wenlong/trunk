function varargout = init( this, varargin )



if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'poislldclutcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'poislldclutcfg' )
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

a = 0.0000001;
stepsize = 0.0001;
for cnt=1:100000
    a = a + stepsize;
    intval1 = exp( log(2*pi*T*Iprime) - log( a) );
    intval2 = exp( log( 2*pi*Iprime) - 2*log(a) + a*T );
    intval3 = -exp( log(2*pi*Iprime) - 2*log(a) );
    Intval = intval1 + intval2 + intval3;
    
    if cnt==1
        preval = Intval;
    end
    if Intval > preval
       break;
    end
    if abs( Intval - this.lambdaod )< 0.05
        break;
    end
end

this.lldeca = a;
this.lldecb = log( Iprime ) + a*T;
this.intatzero = exp( this.lldecb );

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


