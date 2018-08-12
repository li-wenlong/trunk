function varargout = state2init( this )

for k=1:length( this.nodes )
    mynode = this.nodes(k);
    mynode.state2init;
    this.nodes(k) = mynode;
end

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
