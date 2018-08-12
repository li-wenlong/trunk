function m = compmessage(this, l )

% Find the local child node index number for node l
s = find( this.children == l );
if isempty(s)
    warning(sprintf('Node %d is not a child of node %d \n returning empty message',s, this.id));
    m = [];
    return;
end

dt = this.initstate.getdims; % dimensionality of x_t

indeg = length( this.parents); % degree of the node
if isa( this.previnbox, 'gk' ) && sum( this.previnboxlog ) == indeg
    
    sumind = setdiff( [1:indeg], find( this.parents == l ) );
    
    ds = size( this.edgepotentials(s).S, 1) - dt;
    
    Lambda_sum = zeros(ds, ds);
    nu_sum = zeros( ds, 1);
    for i=1:length( sumind )
        Lambda_sum = Lambda_sum + this.previnbox( sumind(i) ).S;
        nu_sum = nu_sum + this.previnbox( sumind(i) ).S*this.previnbox( sumind(i) ).m;
    end
else
    % First messages
    ds = size( this.edgepotentials(s).S, 1) - dt;
    Lambda_sum = zeros(ds, ds);
    nu_sum = zeros( ds, 1);
end
indeg = length( this.children );

U1 = this.C'*this.noisedist.S;% This is for the measurement update;

A = this.edgepotentials(s).S(dt+1:end,1:dt)*...
    ( this.edgepotentials(s).S(1:dt,1:dt) + Lambda_sum + U1*this.C )^(-1);

%Lambda_ts = this.edgepotentials(s).S(dt+1:end,dt+1:end) -A*this.edgepotentials(s).S(1:dt, dt+1:end);
Lambda_ts = -A*this.edgepotentials(s).S(1:dt, dt+1:end);
nu_ts = -A*( nu_sum + U1*this.y );

C_ts = Lambda_ts^(-1);
m_ts = C_ts*nu_ts;

% m = cpdf( gk( C_ts, m_ts ) );

dummy = gk; % create a dummy Gaussian Kernel Object first and then modify 
% its fields since these are not positive definite and the constructor
% would give an error if we want to directly create a gk object with the parameters below.
dummy.S = Lambda_ts;
dummy.C = C_ts;
dummy.m = m_ts;
m = dummy;
      