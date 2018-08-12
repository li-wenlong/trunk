function varargout = recmeas( this, y_vect)
% function varargout = @node.recmeas( y)
% Records the measurement value y in @node.yk to take into account during
% message and update computations.

this.y = y_vect;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), this );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end