function varargout = initthetas( this, varargin )


if length( this.numthetas) == this.dim
    thetas = gengrid( this.numthetas, this.limits );
else
    thetas = gengrid( ones(this.dim,1)*( prod( this.numthetas )^(1/this.dim) ) , this.limits );
end

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
