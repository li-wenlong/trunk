function [lhood, varargout] = parlhoodpois( this, predintensity, sensor )

Z = this.Z; % get the observation set

Zk_len = length(Z.Z);
P_D = this.probdetection;
% lambda_c = sensor.clutter.getlambda;
meas.P_D = this.probdetection;
meas.clutterpdf = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);
flt_param.N_max = length( this.postcard )-1;
flt_param.rho = this.numpartpersist;
flt_param.Lmax = this.maxnumpart;

this.proddenum = 1;
this.sumdenum = 0;

% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = predintensity.s.particles.getweights...
    *predintensity.mu ;
p = predintensity.s.particles.getstates;

% Likelihood function matrix
% row m is for the m th observation, col n is for the n th particle
% M is the mask for FoV
[Gk, M, ppol] = sensor.likelihood( Z, p );


this.sumdenum = 0;
this.proddenum = 1;
loglhood = 0;
%Update the weights
w_upd_comp = zeros(length(w_pred),Zk_len+1);
for i=1:Zk_len
    w_upd_comp(:,i) = P_D*Gk(i,:)'.*w_pred;
    denom = ( sum(w_upd_comp(:,i))  + meas.clutterpdf(i) ); % + this.nbintensity.mu*0
    w_upd_comp(:,i) = w_upd_comp(:,i)/denom;
    this.sumdenum = this.sumdenum + (1/denom);
    this.proddenum = this.proddenum*denom;
    loglhood = loglhood + log(denom);
end  
   
lhood = this.proddenum*exp( -P_D*predintensity.mu );
loglhood = loglhood -P_D*predintensity.mu;

if nargout >1
    varargout{1} = loglhood;
end