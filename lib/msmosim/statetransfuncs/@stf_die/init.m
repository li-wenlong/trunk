function varargout = init(this, varargin )
if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'stf_diecfg' )
        error(sprintf( 'Wrong type of config class: %s instead of stf_nonlin1cfg /n could not proceed with initialisation...', class(cfg) ));
    end
else
    cfg = stf_lingausscfg;
end
this.cfg = cfg;
% Set the state labels and substitute the state from the underlying
% state space
this.setstatelabels( cfg.statelabels );
this.substate( cfg.state );
this.catstate;
% Set the initial time
this = this.settime( cfg.inittime(1));
this.deltat = cfg.deltat(1);

this.F = cfg.F;
this.Q = cfg.Q;


%this.i1 =  this.i1.init('deltat', this.deltat, 'state', this.location);
%this.i2 =  this.i2.init('deltat', this.deltat, 'state', this.orientation );
%this.i3 =  this.i3.init('deltat', this.deltat, 'state', this.velocity );
%this.i4 =  this.i4.init('deltat', this.deltat, 'state', this.angularvelocity );

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


