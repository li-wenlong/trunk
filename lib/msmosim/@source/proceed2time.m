function varargout = proceed2time(this, time, varargin )


if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time to proceed is a scalar!');
end
time = time(1);

velearth = [0 0 0]';
if nargin == 3
    if ~isa( varargin{1}, 'kstate')
        error('The second argument should be the parent state!');
    end
    velearth = varargin{1}.velearth;
end

this.time = time;
this.velearth = velearth;

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
