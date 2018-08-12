function varargout = onestep(this, varargin )

if nargin >= 2
    dt = varargin{1}(1);
    if ~isnumeric( dt )
       error('Input should be a scalar'); 
    end
else
    dt = this.deltat;
end
 
% Proceed the time
this = this.settime( this.time + dt);

% Find the time slot from the recorded track
timeins = cell2mat({this.rectrack.time});

ind = find( this.time>= timeins );

if ~isempty(ind)
this.state = this.rectrack(ind(end)).state.getstate(this.statelabels);
end

this = this.substate(this.state);
% Update the step
this.catstate;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

