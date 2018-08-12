function m = compnbpmessage(this, l )

% Find the local child node index number for node l
s = find( this.children == l );
if isempty(s)
    warning(sprintf('Node %d is not a child of node %d \n returning empty message',s, this.id));
    m = [];
    return;
end
outdeg = length( this.children );

dt = this.initstate.getstatedims; % dimensionality of x_t
ds = this.nestates{s}.getstatedims - dt;
deg = length( this.parents); % degree of the node


% Find the indices of parents other than l
sp = find( this.parents == l );
exs = setdiff( [1:indeg] , sp );
    
if (isa( this.previnbox, 'particles' )||isa( this.previnbox, 'kde' ) )...
        && length( this.previnbox) == deg
    
   
    % Sample from the "edge potential"
    [edgepars, edgews ] = feval( this.edgepotentials{s}, this.epotobjs{s},...
        this.initstate.states, this.state, this.previnbox(s), this.previnbox(exs) );    
else
    % First messages
    

    % Sample from the "edge potential"
    [edgepars, edgews ] = feval( this.edgepotentials{s}, this.epotobjs{s},...
        this.initstate.states, this.state, [], [] );
    
end

m = kde( edgepars, 'rot', edgews, 'g' );
      