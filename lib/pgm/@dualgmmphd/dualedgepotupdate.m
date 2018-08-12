function [this, thisrev ] = dualedgepotupdate( this, thisrev, nodei, nodej )
% dualedgepotupdate method of the class @dualgmmphd
% 1) updates the domain of the edgepot object
% 2) evaluates the edge potential at the newly found points
% 3) Updates the kde representation of the edgepotential with these points

% Murat Uney 01.06.2017
% Murat Uney 31.05.2017

global DEBUG_PMRF

if DEBUG_PMRF
    disp(sprintf('Inside update function for the edge (%d,%d) ', this.e )); 
end

% 1) Update the domain of the edgepot object
bi = nodei.getstate; % Belief of the ith node
bj = nodej.getstate; % Belief of the jth node

% Find the thetas to evaluate the edge potential at
if isempty( this.thetas )
    if (isempty(bi) || isempty(bj))
        % First initialisation of thetas
        this.initthetas;
        thisrev.thetas = - this.thetas;
        
        thetas = this.thetas;
    else
        error('Initialisation of theta_i - theta_j s cannot be handled!');
    end
else
    % Possibly not the first set of thetas
     localstate = bi.states;
     remstate = bj.states;
     
     thetas = remstate - localstate;
     
     % Append these to the recently evaluated set of thetas
     this.thetas = [this.thetas, thetas];
     thisrev.thetas = -this.thetas;
end

% 2) Evaluate the edge potential at these points
numsamples = size( thetas, 2);

theta_i  = zeros( size( thetas ) );
theta_j  = thetas;
    
timewindow = this.T;
winlength = length( timewindow );

% Initiate buffer for the dual terms
dualterms = zeros(numsamples,winlength);

% Initiate buffer for the log dual terms
logdualterms = zeros(numsamples,winlength); 

% The buffers below will be mainly for test/verification purposes
logsijs = zeros(numsamples,winlength);
logsjis = zeros(numsamples,winlength);


filteri = this.filteri;
sensori = this.sensori;


filterj = this.filterj;
sensorj = this.sensorj;

tstart = tic;
for tcnt = 1:length( timewindow )
    
    stepcnt = timewindow(tcnt);
    % At sensor i
    % the outcome of Chapman-Kolmogorov over the previously received
    % posterior is the prediction distribution:
    predj = this.predjs{ tcnt };
    predjati = predj;
    filteri.Z = this.sensorbufferi( tcnt );
    
    % At sensor j
    predi = this.predis{ tcnt };
    prediatj = predi;
    filterj.Z = this.sensorbufferj( tcnt );
    
    for k=1:numsamples
        
        theta_i_val = theta_i(:,k);
        theta_j_val = theta_j(:,k);
        
        % at sensor i
        predjati.s.gmm.pdfs = cotranx2y( predj.s.gmm.pdfs, theta_j_val, theta_i_val  );
        [siGjval, logsiGjval]  = filteri.parlhoodpois( predjati, sensori );
        
        % At sensor j
        prediatj.s.gmm.pdfs = cotranx2y( predi.s.gmm.pdfs, theta_i_val, theta_j_val );
        [sjGival, logsjGival]  = filterj.parlhoodpois( prediatj, sensorj );
        
        logsijs(k,tcnt) = logsiGjval;
        logsjis(k,tcnt) = logsjGival;
        
        logdualterms(k,tcnt) = logsiGjval + logsjGival;
        dualterms(k,tcnt) = exp( logsiGjval + logsjGival );
        
    end
end
telapsed = toc(tstart);

% save the logpsi history
logpsishist = this.logpsis; 

% Find the loglhood by summing over the time
loglhood = sum( logdualterms, 2 );
% Cat to the logpsi history
this.logpsis = [ this.logpsis; loglhood ];

% Covert log terms to non-log after normalisation
dualterms = log2norm( {loglhood} );
alldualterm = log2norm( {this.logpsis} );

% Save into the history
this.psis = [alldualterm{1}];

% Here, we scale the log likelihoods for smoothing
% before adding to the history 
%
% Read the parameter from the updateparams @scheduler object
uparam = this.updateparams;
sfact = uparam.getentry; % Get scale factor
this.updateparams = uparam;

% Prepare the scale factor array
sfactarray = abs(sfact)*ones( size(loglhood) );
sloglhood = sfactarray.*loglhood;

slogpsis = [logpsishist; sloglhood ];

sdualterms = log2norm( {sloglhood} ); % scaled dual terms
salldualterm = log2norm( {slogpsis} );

spsis = [salldualterm{1}];

%potobj = particles( 'states', this.thetas, 'weights', this.psis, 'labels', this.e(1) );
potobj = particles( 'states', this.thetas, 'weights', spsis, 'labels', this.e(1) );
potobj.findkdebws('nonsparse');

this.potobj = potobj;

% Now, save the results on the reverse edge
thisrev.psis = this.psis;
thisrev.logpsis = this.logpsis;

revpotobj = potobj;
revpotobj.states = thisrev.thetas;

thisrev.potobj = revpotobj;


% Increase both edge object's update count by one
    
this.updatecount = this.updatecount + 1;
thisrev.updatecount = thisrev.updatecount +1;

this.tupdate = [this.tupdate; telapsed];
thisrev.tupdate =[thisrev.tupdate; telapsed]; 


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


