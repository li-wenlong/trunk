function varargout = calcinvpolarmodel(this )

this.stdoneorange = 1/( abs( this.maxrange - this.minrange  )/6 );
this.meanoneorange = 1/((this.maxrange - this.minrange  )/2);


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
