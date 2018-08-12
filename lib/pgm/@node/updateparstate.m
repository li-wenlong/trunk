function  varargout = updateparstate(this )


% Use the messages in the inbox if not empty
% degree of the node
deg = length( this.parents );
if (isa( this.inbox, 'particles' )||isa( this.inbox, 'kde' ) ) && length(this.inbox) == deg
    % Update the state
    ds = this.state.getstatedims;
    numsamples = this.state.getnumpoints;
    
         
    inmes = {};
    if isempty( this.y )
%         inmes{ 1 } =  kde( this.initstate.states, 'rot',...
%             (this.initstate.weights.*( (wstate.^(1-deg))'))','g' );
        inmes{ 1 } =  kde( this.initstate.states, 'rot',...
            (this.initstate.weights)','g' );
    else
        
        wmeas = this.noisedist.evaluate( this.y - this.C*this.initstate.states );
        %         state_ = particles( 'states', this.initstate.states, 'weights',...
        %         ( this.initstate.weights.*wmeas' ).*(wstate.^(1-deg))' );
        state_ = particles( 'states', this.initstate.states, 'weights',...
            ( this.initstate.weights.*wmeas' ) );
        state_.findkdebws;
        state_.regwkde;
        
        
        inmes{ 1 } = kde( state_.states, 'rot',...
            state_.weights','g' );
    end
    
    % if inbox is not kde; create kde objects
    if isa(this.inbox, 'particles')
        
        for j=1:length(this.inbox)
            inmes{end+1} = kde( this.inbox(j).getstates, 'rot', this.inbox(j).getweights', 'g');
        end
    elseif isa(this.inbox, 'kde')
        % Store in a cell array as expected by @kde.productApprox
        
         for j=1:length(this.inbox)
            inmes{end+1} = this.inbox(j);
        end
    end
    
  
    
    st = kde(randn(ds,numsamples), 'rot', ones(1, numsamples), 'g' );
   % st = productApprox( st, inmes, {},{}, 'epsilon', 1e-2 ) ;
    %st = productApprox( st, inmes, {},{}, 'exact' ) ;
      
     st = productApprox( st, inmes , {},{}, 'import', ...
                                min(  deg ,4 ) ) ;
         
    ustate = particles( 'states', getPoints(st),'weights', getWeights(st) ); 
    ustate = ustate.findkdebws;
    ustate = ustate.resample;
    this.state = ustate;
    
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

 