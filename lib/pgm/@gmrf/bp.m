function varargout = bp( this, varargin )


global DEBUG_GMRF 
global DEBUG_GMRF_CARRAY 
global DEBUG_VERBOSE

if DEBUG_GMRF && DEBUG_VERBOSE
    disp(sprintf('BP messages are sent in accordance with the messaging schedule specified'))
end

% Apply the message schedule
[M] = length( this.mschedule.pattern );

for i=1:M
    % ith iteration
    if DEBUG_GMRF && DEBUG_VERBOSE
        disp(sprintf('iteration %d',i));
    end
    % Take the messaging schedule
    mypat = this.mschedule.pattern{i};
    
    for k=1:size( mypat )
        e = mypat(k,:);
        if DEBUG_GMRF && DEBUG_VERBOSE
            disp(sprintf('Messaging from %d to %d', e(1), e(2) ));
        end
        tnode = this.nodes( e(1) );
        rnode = this.nodes( e(2) );
        
        message2pass = tnode.compmessage( e(2) ); % Compute the outgoint message
        if isempty( message2pass )
            warning(sprintf('Message from %d to %d empty in iteration number %d', e(1), e(2), i ));
        end
        
        rnode = rnode.recmessage( e(1), message2pass ); % Save the received message
        
        this.nodes( e(1) ) = tnode;
        this.nodes( e(2) ) = rnode;     
    end
    
    % Update states
    for k=1:length( this.V )
        unode = this.nodes( k );
        % Update the node states if all messages all received
        if unode.rxallmessages
            if DEBUG_VERBOSE && DEBUG_GMRF
                disp(sprintf('Updating the state of node %d', k ));
            end
            unode.updatestate;
        end
        this.nodes( k ) = unode;
    end
    
    if exist('DEBUG_GMRF') && exist('DEBUG_GMRF_CARRAY')
        if DEBUG_GMRF
            DEBUG_GMRF_CARRAY{end+1} = this;
        end
    end
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
