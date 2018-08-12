function varargout = onestep(this, varargin )


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),{});
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = {};
end

