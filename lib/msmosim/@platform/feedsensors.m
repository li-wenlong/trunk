function varargout = feedsensors( this, src, time )

if ~isa( src, 'cell' )
    error('The input should be a cell array.');    
else
    for i=1:length(src)
       if ~isa( src{i} , 'source' )
          error('The entries of the cell array should be of type source.'); 
       end
    end
end 

if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time to proceed is a scalar!');
end
crrnttime = time(1);

%% Get the time stamp
%%crrnttime = this.stfobjs{ this.crrntstfnum }.gettime;
% For now use the time stamp sent from above

% Pass the source list to the sensors together with the parent state
ps = this.getkstate;
for i=1:length( this.sensors )
    % for this sensor, covert the earth coordinate system to sensor
    % coordinate system
   this.sensors{i}  = this.sensors{i}.setsrclist( src, crrnttime, ps );
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
