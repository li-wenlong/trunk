function varargout = proceed2timestamps( this, timestamps )

timestamps = timestamps(:);
if ~isa(timestamps, 'numeric' )
    error('The time to proceed is a numeric array scalar!');
end

for i=1:length(timestamps)
    this = this.proceed2time(timestamps(i));
end

% Return the resultant object
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
