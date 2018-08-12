function [lhood, varargout] = parlhoodparfov( this, localposterior, predintensity, sensor, thetaj, rangemaxj )

Z = this.Z; % get the observation set

Zk_len = length(Z.Z);
P_D = this.probdetection;
lambda_c = sensor.clutter.getlambda;
meas.P_D = this.probdetection;
meas.clutterpdf = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);
flt_param.N_max = length( this.postcard )-1;
flt_param.rho = this.numpartpersist;
flt_param.Lmax = this.maxnumpart;

this.proddenum = 1;
this.sumdenum = 0;

% The area of the overlapping region for the (circular) FoVs:
% A = 2*( r^2cos^-1(d/2r) - (d/4) sqrt(4r^2-d^2) );
% where r = R_max, d = ||\theta_j||
rseg = rangemaxj;
dseg = norm( thetaj );
Aseg = rseg^2*acos( dseg/(2*rseg) ) - (dseg/4)*sqrt(4*rseg^2 - dseg^2 );

Aolap = 2*Aseg;
Ainoj = pi*rseg^2 - Aolap;


% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = predintensity.s.particles.getweights...
    *predintensity.mu ;
p = predintensity.s.particles.getstates;

% Find the localposterior outsied the FoV of sensor j
localpardummy = localposterior.s.particles;

localpardummy.rotrans( 'alpha', 0, 'translate', -[ thetaj 0 0]' );
[rempardummy, incl] = localpardummy.polargate('rangemax', rangemaxj);
excl = setdiff( [1:localpardummy.getnumpoints],  incl);

sumw_xinoj = sum( localposterior.s.particles.weights(excl)  );
lambda_xinoj = localposterior.mu*sumw_xinoj;
w_winoj = localposterior.s.particles.weights(excl)/sumw_xinoj;
p_xinoj = localposterior.s.particles.states(:,excl);


% Likelihood function matrix
% row m is for the m th observation, col n is for the n th particle
% M is the mask for FoV
[Gk, M, ppol, logGk] = sensor.likelihood( Z, p );

if ~isempty(p_xinoj)
    [Gk_inoj, M_inoj, ppol_inoj, logGk_inoj] = sensor.likelihood( Z, p_xinoj );
else
    Gk_inoj = zeros(Zk_len,1 );
end

this.sumdenum = 0;
this.proddenum = 1;
loglhood = 0;

lambda_Zinoj = lambda_xinoj*P_D;
%Update the weights
allcontr_pred = 0;
for i=1:Zk_len
    % Contribution of the intersection via the predicted thing
    contr_pred = P_D*Gk(i,:)'.*w_pred;
    
    % Contribution of the i/j
    contr_Zinoj = (lambda_xinoj/lambda_Zinoj)*P_D*Gk_inoj(i,:)'.*w_winoj;
    
    denom = ( lambda_Zinoj*sum(contr_Zinoj) + sum( contr_pred )  + meas.clutterpdf(i) ); % this terms is as it appears in fusion 2016
    
  %  denom = ( 0*lambda_Zinoj*sum(contr_Zinoj) + sum( contr_pred )  + meas.clutterpdf(i) ); 
  %% this term zeroes out the contribution of the
  %%  spurious measurements from X_i/j in the product over measurements.
  %%  Note that, lambda_Zinoj enters the calculations on the exponential
  %%  term calculations following this loop
  
  
    % denom = ( lambda_Zinoj*(1/Ainoj) + sum( contr_pred )  + meas.clutterpdf(i) ); %
    %% this term uses a uniform spatial density for Z_i/j, uniform over the region S_i/j
    %% Ainoj is the area of this region. 
    
    this.proddenum = this.proddenum*denom;
    loglhood = loglhood + log(denom);
    
    % The contributions from X_i \cap j is collected below to be checked
    allcontr_pred = allcontr_pred + sum( contr_pred ) ;
end  
if allcontr_pred <  lambda_Zinoj^Zk_len*(1/Ainoj)*prod( meas.clutterpdf )
    % If the contribution from X_i \cap j is zero, effectively, the
    % measurement model will effectively contain only spurious
    % measurements:
    loglhood = loglhood - lambda_c - lambda_Zinoj;
else
    % Because there is non-negligible contribution from X_i \cap j, the
    % contribution in the exponential term will be as follows (in the log domain): 
    loglhood = loglhood -P_D*predintensity.mu - lambda_c - lambda_Zinoj;
end

lhood = exp( loglhood );

if nargout >1
    varargout{1} = loglhood;
end