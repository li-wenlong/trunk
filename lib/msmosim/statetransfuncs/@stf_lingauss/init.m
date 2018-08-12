function varargout = init(this, varargin )
if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'stf_lingausscfg' )
        error(sprintf( 'Wrong type of config class: %s instead of stf_nonlin1cfg /n could not proceed with initialisation...', class(cfg) ));
    end
else
    if ~isa( this.cfg, 'stf_lingausscfg' )
        cfg = stf_lingausscfg;
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

% The dimensions of the state is
dimstate = length( cfg.state );
if size(cfg.F,2) ~= dimstate
    error('The dimensionality of the state and that of linear Transform domain mismatch!');
else
    this.F = cfg.F;
end
% The dimensions of the process noise should match that of the state
dimobs = size(this.F,1);
if sum(abs(size(cfg.Q)-[dimobs,dimobs]))~=0
    error('The dimensionality of the observation and that of the noise covariance mismatch!');
else
    this.Q = cfg.Q;
    if rank(this.Q) == size(this.Q, 2)
        this.sqQ = sqrtm( this.Q );
    else
        [sqQ, res] = sqrtm( this.Q );
        if sum(sum(abs( sqQ*sqQ - this.Q )))>eps
            error('The process noise covariance has not square root matrix');
        else
            this.sqQ  = sqQ;
        end
    end
end

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


