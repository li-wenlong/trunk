function  varargout = updateparstatewav(this )
% This function updates the current state with the available messages and
% does not check if all the messages from all the neighbours have arrived.

% 07.05.2017

global DEBUG_PMRF DEBUG_VERBOSE
% Use the messages in the inbox if not empty
% degree of the node

if this.id == 12
    aaa = 1230;
end

deg = length( this.parents );
if ~isempty( this.inbox)
   
        % get the node potential
        if ~isempty( this.initstate )
            % non-uniform dist.
            inmes = this.initstate;
        else
           %  uniform dist. 
           inmes = particles([]);
        end
            
        for j=1:length(this.inbox)
            if this.inboxlog(j) % if message received this round
                if isa( this.inbox{j}, 'particles' )
                    inmes(end+1) = this.inbox{j};
                else
                    if DEBUG_PMRF && DEBUG_VERBOSE
                        disp( sprintf('Node %d has wrong message from %d: %s', this.id, this.parents(j),class( this.inbox{j} ) ));
                    end
                end           
            end
        end     
        st = prodisgausspair( inmes );        
        this.state = st;
        if DEBUG_PMRF && DEBUG_VERBOSE
            disp( sprintf('Node %d updated its belief state', this.id ));
        end
  
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

 