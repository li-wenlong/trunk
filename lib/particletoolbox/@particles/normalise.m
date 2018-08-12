function varargout = normalise( p )

p.weights = p.weights/sum( p.weights );

if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), p );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p;
end