function varargout = findparlhood( this, sensors )

P_D = sensors(1).pd;

this.parlhood = exp( - P_D*this.mupred )*prod(this.proddenum);

loglhood = log( prod(this.proddenum) ) - P_D*this.mupred;



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    if nargout >= 1
       varargout{1} = this;
    end
    if nargout>= 2
        varargout{2} = this.parlhood;
    end
    if nargout>=3
        varargout{3} = loglhood;
    end
end
