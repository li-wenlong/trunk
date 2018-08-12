function  varargout = updateparstate(this )


% Use the messages in the inbox if not empty
% degree of the node
deg = length( this.parents );
if (isa( this.inbox, 'particles' )||isa( this.inbox, 'kde' ) ) && length(this.inbox) == deg
    
    % Get the dim. and number of samples
    ds = this.initstate.getstatedims;
    numsamples = this.initstate.getnumpoints;
    
    if deg == 1
        % There is only one element in the inbox
        % and the p(x) s cancel out in
        % p(y|x) p(x)/p(x) m_ij(x)
        % So, we simply resamply mij with the measurement likelihoods
        if isa(this.inbox, 'particles')
            mij = this.inbox(1);
        elseif isa(this.inbox, 'kde')
            % Store in a cell array as expected by @kde.productApprox
            wmij = getWeights(  this.inbox(1) );
            mij = particles('states', getPoints( this.inbox(1)), 'weights', wmij');
        end
        
        % Evaluate the product at the measurement if there is any
        if isempty( this.y )
            wmeas = ones(1,numsamples)/numsamples;
            wmeas = wmeas';
        else
            wmeas = this.noisedist.evaluate( this.y - this.C*mij.states );
            wmeas = wmeas';
        end
        
        state_ = particles( 'states', mij.states, 'weights',...
            wmeas(:)  );
        state_.findkdebws;
        state_.regwkde;
        
    else
        % More than one neighbours, i.e., deg>1
        % p(y|x) p(x)/p(x)^(|ne(j)|) \prod mij(x_j)
        % First resample for the measurement and the
        % (p(y|x)p(x_j) p(x_j)^(-|ne(j)|) part to multiply with the incoming
        % messages 
        
        % First, the p(y|x)p(x_j) part (lospost)
        initstate_ = this.initstate;
        
        locprior = kde( initstate_.states, 'rot', initstate_.getweights', 'g' );
        
        % now, we have the myopic posterior in initstate_
        
        
        inmes = {};
       % inmes{1} = kde( initstate_.states, 'rot', initstate_.weights', 'g');
       % inmes{1} = kde( this.initstate.states, 'rot',...
       %     (this.initstate.weights)','g' );
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
        
        
        % Multiply the incoming messages
        st = kde(randn(ds,numsamples), 'rot', ones(1, numsamples), 'g' );
        st = productApprox( st, inmes, {},{}, 'epsilon', 1.0e-2 ) ;
        %st = productApprox( st, inmes, {},{}, 'exact' ) ;
        
        wp = initstate_.evaluate( getPoints(st) );
        
          % Evaluate the product at the measurement if there is any
        if isempty( this.y )
            wmeas = ones(1,numsamples)/numsamples;
            wmeas = wmeas';
        else
            wmeas = this.noisedist.evaluate( this.y - this.C* getPoints(st) );
            wmeas = wmeas';
        end
        
       
        % scaled st
        scst = kde(  getPoints(st), 'rot', (wp.^(-deg)).*wmeas' );
        
        % Multiply the scaled product of incoming messages and the local
        % posterior
        inmes = {locprior, scst };
        st2 = kde(randn(ds,numsamples), 'rot', ones(1, numsamples), 'g' );
        st2 = productApprox( st2, inmes, {},{}, 'epsilon', 1e-4) ;
        
        
        
        
        wst = getWeights(st2);
        state_ = particles( 'states', getPoints(st2),'weights', wst(:) );
        state_ = state_.findkdebws;
        
        
      
        
        %    % Below: First resample with the measurement likelihood and then scale with the prior
        %
        %     if isempty( this.y )
        %         wmeas = ones(1,numsamples)/numsamples;
        %         wmeas = wmeas';
        %     else
        %         wmeas = this.noisedist.evaluate( this.y - this.C*ustate.states );
        %         wmeas = wmeas';
        %
        %         ustate = particles( 'states', ustate.states, 'weights', wmeas(:) );
        %         ustate.findkdebws;
        %         ustate.regwkde;
        %     end
        %
        %     wp = this.initstate.evaluate( ustate.states);
        %     wpweights = ( wp.^(-deg) )';
        %     state_ = particles( 'states', ustate.states, 'weights', wpweights(:) );
        %     state_.findkdebws;
        %     state_.regwkde;
        
    end
    this.state = state_;
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

 