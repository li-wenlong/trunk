function varargout = recedgepotential(this, l, ep )


% Find the local parent node index number for node l
for k=1:length( l)
    s = find( this.children == l(k) );
    if isempty(s)
        warning(sprintf('Node %d is not a child of node %d \n unable record the edgepotential',l(k), this.id));
        return;
    end
    s = s(1);   
    this.edgepotentials{ s } = ep(k);
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
