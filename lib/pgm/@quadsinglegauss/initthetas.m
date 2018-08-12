function varargout = initthetas( this, varargin )



thetas = gengrid( ones(this.dim,1)*( this.numthetas^(1/this.dim) ) , this.limits ); 

this.thetas = thetas;




if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
