function  varargout = updateparstate(this )
% This function updates the current state upon receiving all messages from
% parents, as in the regular loopy BP.

global DEBUG_PMRF DEBUG_VERBOSE

% Use the messages in the inbox if not empty
% degree of the node
deg = length( this.parents );
if sum(this.inboxlog) == deg
    % Update the state
           
    % get the node potential
    if ~isempty( this.initstate )
        % non-uniform dist.
        inmes = this.initstate;
    else
        %  uniform dist.
        inmes = particles([]);
    end 
    
    for j=1:length(this.inbox)  
        if isa( this.inbox{j}, 'particles' )
            inmes(end+1) = this.inbox{j};
        else
            if DEBUG_PMRF && DEBUG_VERBOSE
                disp( sprintf('Node %d has wrong message from %d: %s', this.id, this.parents(j),class( this.inbox{j} ) ));
            end
        end     
    end
 
   
    st = prodisgausspair( inmes );
   
    this.state = st;
    
     if DEBUG_PMRF && DEBUG_VERBOSE
            disp( sprintf('Node %d updated its belief state', this.id ));
     end
        
else
    % no message to update
    error( sprintf('Node %d does not have sufficient messages in the inbox to update its state', this.id ));
end
this.previnbox = this.inbox;
this.previnboxlog = this.inboxlog;
this.inbox = {};
this.inboxlog = this.inboxlog*0;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

 