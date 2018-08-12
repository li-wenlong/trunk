function varargout = init(this, varargin )
if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'stf_recordedcfg' )
        error(sprintf( 'Wrong type of config class: %s instead of stf_nonlin1cfg \n could not proceed with initialisation...', class(cfg) ));
    end
else
    cfg = stf_recordedcfg;
end
this.cfg = cfg;

% Get the inital values from the first entry in the recorded track
inittreport = cfg.rectrack(1);

% Set the state labels and substitute the state from the underlying
% state space
this.setstatelabels( inittreport.state.statelabels );
this.substate( inittreport.state.state );
this.catstate;
% Set the initial time
this = this.settime( inittreport.time );

if length( cfg.rectrack )>=2
    this.deltat = cfg.rectrack(2).time - cfg.rectrack(1).time;
else
    this.deltat = 0;
end

this.rectrack = cfg.rectrack;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

