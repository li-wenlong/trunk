function varargout = updateconsvel(this, deltat )

olddeltat = this.F(1,3);
qfactor = max( this.Q(4,4)/olddeltat, 0.0001) ;

this.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];

this.Q = qfactor*[...
     deltat^3/3 0 deltat^2/2 0;...
     0 deltat^3/3 0 deltat^2/2;...
     deltat^2/2 0 deltat 0;...
     0 deltat^2/2 0 deltat];
 
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
 