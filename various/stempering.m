function varargout = stempering( f, sen, ths, Zs, St )



lambdas = [1/St:1/St:1];
lambdas = lambdas/sum(lambdas);
    
th = ths; % initial set of parameter particles
 % Find the likelihoods (ll below is the log likelihood array)
[ ll , pz ] = paramlhood(  f, sen, th, Zs ); % step 6


[ d, N ] = size(th);
for s=1:St % For St stages of importance sampling with progressive improvement
       
    % Find lhood^lambda_s and normalise weights 
    lambda_s = lambdas(s);
    raisedlhoods = exp( ll*lambda_s ); % step 14
    
    if sum(raisedlhoods) == 0
        raisedlhoods = ones(size(raisedlhoods));
    end
    raisedlhoods = raisedlhoods/sum(raisedlhoods); % normalise (step 15)
     % will use these also as weights of the proposal distribution in this stage
   
%      lhoods = exp( ll );
%      lhoods = lhoods/sum(lhoods); % normalise the weights
    
    % Find the sample mean and variance for the Gaussian proposal
    % distribution
    [Cs, Lambdas] = grotcovmat( th,  'weights', raisedlhoods, 'myeps',1 ); % Step 16
    ms = mean( th');
    
    % Resample: step 18
    idx = resample( raisedlhoods, N );
    th_tilde = th(:, idx);
    ll_tilde = ll( idx );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MCMC Move: Steps 19-28
    
    % Step 19
    gs = cpdf( gk(Cs,ms ) );
    newpar = gs.gensamples( N ); % Here, the weights are also taken into account, so corresponds to
    %  sampling from the empirical distribution (regularised kde) to obtain \theta_j^{s,*}
   
    % We will either accept from newpar or the resampled set th_tilde
    
    % Step 20
    % Find the likelihoods of regpars
    [ ll_star , pz_ ] = paramlhood(  f, sen, newpar, Zs );
    
    % Step 21
    gs_star = gs.evaluate(newpar);
    gs_tilde = gs.evaluate( th_tilde );
    
    % Acceptance probabilities
    accprob = min( [ ones(1, N ); (exp(lambda_s*( ll_star - ll_tilde   )  )).*( gs_tilde./gs_star ) ] );
    usample = rand(1,N);
    aind = find( usample< accprob ); % Find the accepted samples
    
    th(:,aind) = newpar(:,aind);
    ll(aind) = ll_star(aind);
    % else, use the regularised samples
    oind = setdiff([1:N],aind);
    
    th(:, oind ) = th_tilde(:,oind);
    ll(oind) = ll_tilde(oind);
    
    % End of the MCMC Move
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
end % Outer loop over s

if nargout >= 1
    varargout{1} = th;
end
   
if nargout >= 2
    varargout{2} = ll;
end
