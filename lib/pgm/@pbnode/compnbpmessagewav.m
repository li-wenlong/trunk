function m = compnbpmessagewav(this, l )
% @pbnode.compnbpmessagewav( l )
% computes the message to child l with the available (messages) - hence
% wav.

% Find the local child node index number for node l
s = find( this.children == l );
if isempty(s)
    warning(sprintf('Node %d is not a child of node %d \n returning empty message',s, this.id));
    m = [];
    return;
end
indeg = length( this.parents );

% Find the indices of parents other than l
sp = find( this.parents == l );
exs = setdiff( [1:indeg] , sp );

dt = this.initstate.getstatedims; % dimensionality of x_t
ds = this.nestates{s}.getstatedims - dt;
deg = length( this.parents); % degree of the node

% Find the messages to be taken into account in the message computation
previnboxexs = particles([]);
numfacts = 0;
if~isempty( this.previnbox )  
    % Not the first message
    for i=1:length( exs )
        if this.previnboxlog( exs(i) )
            if isa( this.previnbox{exs(i) }, 'particles' )
                previnboxexs(end+1) = this.previnbox{exs(i) };
                numfacts = numfacts + 1;
            else
                error(sprintf('Error while computing message from %d to %d: \n  Object of type %s in the previous inbox instead of @particles',...
                    this.id, this.parents(sp) ,class(this.previnbox{1} )) );
            end
            
        end
    end  
end

% Also get the initial belief if there is one - if not, it will be taken as
% a constant
parr = previnboxexs;
numfacts = 0;
% Add mkjs to the product cell array
if ~isempty( this.initstate )
    parr(end+1) = this.initstate;
    numfacts = numfacts + 1;
end

if ~isempty( parr )
    st = prodisgausspair( parr );
else
    error('Empty message inbox and initial state to compute the message');
end

if isequal( this.edgepotentials{s}.potfun, @edgepotsamplerwor )
    
     [p] = feval( this.edgepotentials{s}.potfun, this.edgepotentials{s}.potobj, st );
     w = st.weights;
else   
    % Sample from the "edge potential"
    [edgepars] = feval( this.edgepotentials{s}.potfun, this.edgepotentials{s}, st.getnumpoints );
    
    p =  st.states + edgepars; % This is valid due to the symmetricity of the edge potential
    w = st.weights;
end

m = particles( 'states', p , 'weights', w, 'labels', this.id );
m.findkdebws;
      