function varargout = substates( phd, states )

if isnumeric(states)
    if ndims(states)>2
        error('The state array should be of dim.s 2 or less!');
    end
    phd.s = phd.s.substates( states );
else
    error('State should be a numeric array!');
end
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1), phd );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = phd;
end