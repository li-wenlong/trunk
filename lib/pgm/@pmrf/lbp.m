function varargout = lbp( this, varargin )
% lbp is the loopy BP method for @pmrf

global DEBUG_VERBOSE
global DEBUG_PMRF
global DEBUG_PMRF_CARRAY

if DEBUG_VERBOSE
    disp(sprintf('Particle BP messages are sent in accordance with the messaging schedule specified'))
    % Exchange the local states with neighbours
    disp(sprintf('Nodes exchanging their local state with their neighbours'));
end

for k=1:length( this.E )
    e = this.E( k, : );
    tnode = this.nodes( e(1) );
    rnode = this.nodes( e(2) );
    
    rnode = rnode.recnestate( e(1), tnode.state  );   
    this.nodes( e(2) ) = rnode;
end

finum = this.iternum+1; % Start index of the iterations.
linum = this.itermax; % Last iteration numer
% Apply the message schedule

for i=finum:linum
    % ith iteration
    if DEBUG_VERBOSE
        disp(sprintf('iteration %d',i));
    end
       
    % Check if any edgepotentials are scheduled to be updated
    myeupd = this.euschedule.getithentry( i );
    if ~isempty( myeupd )
        % Update the edges both (i,j) and (j,i) for any (i,j) in myeupd
        uedges = sue( myeupd );
        for k=1:size( uedges )
            e = uedges(k, : );
            e_ij = findedge( this.E, e );
            e_ji = findrevedge( this.E, e );
            if DEBUG_VERBOSE && DEBUG_PMRF
                disp(sprintf('Updating the edges between %d to %d', e(1), e(2) ));
            end
            nodei = this.nodes( e(1) );
            nodej = this.nodes( e(2) );
            
            edgeij = this.edgepots( e_ij );
            edgeji = this.edgepots( e_ji );
            
            % Find the associated object in the edge potentials
            [edgeij, edgeji] = edgeij.updatefun( edgeij, edgeji, nodei, nodej );
            
            this.edgepots( e_ij ) = edgeij;
            this.edgepots( e_ji ) = edgeji;
            
            nodei.recedgepotential( e(2), edgeij );
            nodej.recedgepotential( e(1), edgeji );
            
            this.nodes( e(1) ) = nodei;
            this.nodes( e(2) ) = nodej;            
        end
    end  
    
    mypat = this.E; % The messaging pattern is the entire set of edges
    
    for k=1:size( mypat )
        e = mypat(k,:);
        if DEBUG_VERBOSE
            disp(sprintf('Messaging from %d to %d', e(1), e(2) ));
        end
        
        tnode = this.nodes( e(1) );
        rnode = this.nodes( e(2) );
        
        message2pass = tnode.compnbpmessage( e(2) ); % Compute the outgoint message
        
        if isempty( message2pass )
            warning(sprintf('Message from %d to %d empty in iteration number %d', e(1), e(2), i ));
        else
            if DEBUG_VERBOSE
                disp(sprintf('Computed...'));
            end
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
            if DEBUG_VERBOSE && DEBUG_PMRF
                disp(sprintf('Updating the state of node %d', k ));
            end
            unode.updateparstate;
        end
        this.nodes( k ) = unode;
    end
    
    this.iternum = i;
    if exist('DEBUG_PMRF') && exist('DEBUG_PMRF_CARRAY')
        if DEBUG_PMRF
            DEBUG_PMRF_CARRAY{end+1} = this;
        end
    end
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
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
