function  varargout = updatestate(this )


% Use the messages in the inbox if not empty
% degree of the node
deg = length( this.parents );
if isa( this.inbox, 'gk' ) && sum(this.inboxlog) == deg
    % Update the state
    ds = this.state.getdims;
    
    U1 = this.C'*this.noisedist.S;% This is for the measurement update;
    
    Lambda_up = this.edgepotentials(1).S(1:ds,1:ds) + U1*this.C;
    nu_up = U1*this.y;
    for i=1:deg
        Lambda_up = Lambda_up + this.inbox(i).S;
        nu_up = nu_up + this.inbox(i).S*this.inbox(i).m;
    end
    C_up = Lambda_up^(-1);
    m_up = C_up*nu_up;
    
    this.state = cpdf( gk( C_up, m_up ) );    
else
    % no message to update
    disp( sprintf('Node %d does not have sufficient messages in the inbox to update its state', this.id ));
end
this.previnbox = this.inbox;
this.previnboxlog = this.inboxlog;
this.inbox = this.inbox([]);
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

 