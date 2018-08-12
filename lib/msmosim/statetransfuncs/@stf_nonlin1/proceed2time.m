function varargout = proceed2time( this, time )

if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time to proceed is a scalar!');
end
time = time(1);

% if time - this.time >eps
%     % Go one step with the minimum 
%     steplen = min( this.deltat, time - this.time );
%     this.onestep( steplen );
%     this.proceed2time(time);
% end
% The recursive call above did not work due to the stack limit

% Find the timesteps if the system deltat is smaller than the difference
timesteps = [];
if this.deltat < time - this.time
    timesteps = [this.time:this.deltat:time];
end

if ~isempty( timesteps )
    for j=2:length(timesteps)
        this = this.onestep( this.deltat );
        if isempty(this)
            error('State transition returned empty cell, might have called dead target for update!')
        end
    end
    remstep = time - max(timesteps);
    if remstep > eps
       this = this.onestep( remstep );
    end
else
    if time-this.time> eps
       this = this.onestep( time-this.time );
    else
      warning('The time to proceed is not ahead of the system time!');
    end
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


        

