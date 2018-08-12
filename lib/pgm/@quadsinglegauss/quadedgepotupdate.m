function [this, thisrev ] = quadedgepotupdate( this, thisrev, nodei, nodej )
% quadedgepotupdate method of the class @quadsinglegauss
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

quadterms = zeros(numsamples,winlength);
logquadterms = zeros(numsamples,winlength); 


% % % The buffers below will be mainly for test/verification purposes
% % logsis = zeros(numsamples,winlength);
% % logsjs = zeros(numsamples,winlength);
% % logrijs = zeros(numsamples,winlength);
% % logrjis = zeros(numsamples,winlength);
% % logscati = zeros(numsamples,winlength);
% % logscatj = zeros(numsamples,winlength);
% % logquadterms2 = zeros(numsamples,winlength); 

tstart = tic;

% Pick the sensor models
Hi = this.sensori.linTrans;
Ri = this.sensori.noiseCov;

Hj = this.sensorj.linTrans;
Rj = this.sensorj.noiseCov;

for tcnt = 1:length( timewindow )
    
    stepcnt = timewindow(tcnt);
    
    % At sensor i
    % the outcome of Chapman-Kolmogorov over the previously received
    % posterior is the prediction distribution:
    predj = this.predjs{ tcnt };
    % received posterior at time tcnt
    postj = this.postjs{ tcnt};
    Zi = this.sensorbufferi( tcnt ).getcat;
    
    % At sensor j
    % the outcome of Chapman-Kolmogorov over the previously received
    % posterior is the prediction distribution:
    predi = this.predis{ tcnt };
    % received posterior at time tcnt
    posti = this.postis{ tcnt };   
    Zj = this.sensorbufferj( tcnt ).getcat; 
    
    for k=1:numsamples
        
        theta_i_val = theta_i(:,k);
        theta_j_val = theta_j(:,k);
        
        
        predjati = cotranx2y( predj, theta_j_val, theta_i_val  );
        
        
        postjati = cotranx2y( postj, theta_j_val, theta_i_val  );
        
        
        prediatj = cotranx2y( predi, theta_i_val, theta_j_val  );
        
        
        postiatj = cotranx2y( posti, theta_i_val, theta_j_val  );
        
        
        sicompatj = measdist( predi, this.sensori.linTrans, this.sensori.noiseCov );
        %    sicompatj is same with sj except it shows how to compute sj at sensor i
        
        sjcompati = measdist( predj, this.sensorj.linTrans, this.sensorj.noiseCov );
        %    sjcompati is same with si except it shows how to compute si at sensor j
        
        % Below is to find the scale factor at any of the sensor
        % platforms:
        pzsGi = cpdf( diag( [ measdist( predi, this.sensori.linTrans, this.sensori.noiseCov ),...
            measdist( postiatj, this.sensorj.linTrans, this.sensorj.noiseCov )] ) );
        
        
        % Below we find p(zi|zj_{1:k})p(zj_k|zj_{1:k-1})
        pzsGj = cpdf( diag( [measdist( postjati, this.sensori.linTrans, this.sensori.noiseCov ),...
            measdist( predj, this.sensorj.linTrans, this.sensorj.noiseCov ) ]) );
        
        
        qterm = cpdf( ( pzsGi)^(1/2) * ( pzsGj )^(1/2)  );
        
        le = qterm.evaluatelog( [this.sensorbufferi( tcnt ).Z.Z; this.sensorbufferj( tcnt ).Z.Z] );
        
        
% %         % Second way to evaluate
% %         
% %         [ esi, erij, sf  ] = quadtermlocal( predi, posti, 1, Zi, Hi, Ri, predj, postj, theta_i_val, theta_j_val, Hj, Rj );
% %         [ esj, erji, sfatj  ] = quadtermlocal( predj, postj, 1, Zj, Hj, Rj, predi, posti, theta_j_val, theta_i_val, Hi, Ri );
% %         le2 = 0.5*esi + 0.5*erij + 0.5*esj + 0.5*erji - sf;
%          
% %         logsis(k,tcnt) = esi;
% %         logrijs(k,tcnt) = erij;
% %         logscati(k,tcnt) = sf;
% %         
% %         logsjs(k,tcnt) = esj;
% %         logrjis(k,tcnt) = erji;
% %         logscatj(k,tcnt) = sfatj;
%%          logquadterms2(k,tcnt) = le2;

        logquadterms(k,tcnt) = le;
        
        quadterms(k,tcnt) = exp( le );
        
    end   
end
telapsed = toc(tstart);

loglhood = sum( logquadterms, 2 );
this.logpsis = [ this.logpsis; loglhood ];

quadterms = log2norm( {loglhood} );
allquadterms = log2norm( {this.logpsis} );


this.psis = [allquadterms{1}];

potobj = particles( 'states', this.thetas, 'weights', this.psis, 'labels', this.e(1) );
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


