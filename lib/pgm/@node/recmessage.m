function varargout = recmessage(this, l, m )


% Find the local parent node index number for node l
s = find( this.parents == l );
if isempty(s)
    warning(sprintf('Node %d is not a parent of node %d \n returning empty message',s, this.id));
    return;
end
s = s(1);

this.inbox(s) = m;
this.inboxlog(s) = 1;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
