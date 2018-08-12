function varargout = setkstate( this, k )

if ~isa(k, 'kstate' )
    error(sprintf('The input argument should be a kstate instance!'));
end

this = this.substate( k.getstate, k.getstatelabels );
this.catstate;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


