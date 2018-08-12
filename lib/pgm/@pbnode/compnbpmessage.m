function m = compnbpmessage(this, l )

% Find the local child node index number for node l
s = find( this.children == l );
if isempty(s)
    warning(sprintf('Node %d is not a child of node %d \n returning empty message',s, this.id));
    m = [];
    return;
end
outdeg = length( this.children );
exs = setdiff( [1:outdeg] , s );

dt = this.initstate.getstatedims; % dimensionality of x_t
ds = this.nestates{s}.getstatedims - dt;
deg = length( this.parents); % degree of the node

% Find the messages to be taken into account in the message computation
previnboxexs = particles([]);
numfacts = 0;
if~isempty( this.previnbox )
    if length( this.previnbox) ~= deg
        error(sprintf('Not all messages from parents received at node %d',s));
    end
    
    previnboxexs = particles([]);
    for i=1:length( exs )
        if this.previnboxlog( exs(i) )
            previnboxexs(end+1) = this.previnbox{exs(i)};
            numfacts = numfacts + 1;
        end
    end
end

% Also get the initial belief if there is one - if not, it will be taken as
% a constant
parr = previnboxexs;
% Add mkjs to the product cell array
if ~isempty( this.initstate )
    parr(end+1) = this.initstate;
    numfacts = numfacts + 1;
end

st = prodisgausspair( parr );
% Sample from the "edge potential"
[edgepars ] = feval( this.edgepotentials{s}.potfun, this.edgepotentials{s}, st.getnumpoints );
p =  st.states + edgepars;
w = st.weights;
m = particles( 'states', p , 'weights', w, 'labels', this.id  );
m.findkdebws;
      