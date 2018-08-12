function varargout = init(this, varargin )
if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'stf_lingauss2cfg' )
        error(sprintf( 'Wrong type of config class: %s instead of stf_nonlin1cfg /n could not proceed with initialisation...', class(cfg) ));
    end
else
    if ~isa( this.cfg, 'stf_lingauss2cfg' )
        cfg = stf_lingauss2cfg;
    end
end

% Set the state labels and substitute the state from the underlying
% state space
this.setstatelabels( cfg.statelabels );
this.substate( cfg.state );
this.catstate;
% Set the initial time
this = this.settime( cfg.inittime(1));
this.deltat = cfg.deltat(1);
this.dT = cfg.dT;
this.psd = cfg.psd(1);

% The dimensions of the state is
dimstate = length( cfg.state );

[F,Q,sQ] = lingauss2( this.dT, this.psd );
this.F = F;
this.Q = Q;
this.srQ = sQ;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


