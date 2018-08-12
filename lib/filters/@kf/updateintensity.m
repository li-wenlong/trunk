function varargout = updateintensity( this, sensor, varargin )

Z = this.Z;

Zk_len = length(Z.Z);
P_D = this.probdetection;
lambda_c = sensor.clutter.getlambda;
meas.P_D = this.probdetection;
meas.clutterpdf = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);
flt_param.N_max = length( this.postcard )-1;
flt_param.rho = this.numpartpersist;
flt_param.Lmax = this.maxnumpart;
cdn_pred = this.predcard;
this.parlhood = 1;

if isempty( this.predintensity )
   if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
        if nargout>=2
            varargout{2} = this.parlhood;
        end
    end
    return;
end

% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = this.predintensity.s.particles.getweights...
    *this.predintensity.mu ;
p = this.predintensity.s.particles.getstates;

pt = p;
if nargin>=3
    pt([1,2],:) = p([1,2],:) - repmat( varargin{1}([1,2]),1, size(p,2) );
end

% Liklihood function matrix
Gk = sensor.likelihood( Z, pt );


% Find the cardinality distribution ratio for it is evaluated at one--out
% over all, i.e., K(Z\{z})/K(Z) for each z \in Z

% cardinality of clutter
ckm1 = poisspdf( Zk_len-1,lambda_c);
ck = poisspdf( Zk_len,lambda_c);

if Zk_len == 0
    fkm1 = 1;
else
    fkm1 = factorial(Zk_len - 1);
end
fk = factorial( Zk_len );

% the ratio is same for all observations since clutter is uniform.
%kratio = ( ckm1*fkm1*meas.clutterpdf^(Zk_len-1) )/( ck*fk*meas.clutterpdf^Zk_len );
% which equals the following:
meas.clutterpdf = meas.clutterpdf(1); % hacking now, later handle non uniform clutter
if Zk_len~= 0
kratio = (ckm1/ck)/(Zk_len*meas.clutterpdf);
else
kratio = ( ckm1*fkm1*meas.clutterpdf^(Zk_len-1) )/( ck*fk*meas.clutterpdf^Zk_len );
end

% Clutter density for Zk_len-1 measurements
cdm1 =  ckm1*fkm1*meas.clutterpdf^(Zk_len-1);
% Clutter denisty for Zk_lem measurements 
cd = ( ck*fk*meas.clutterpdf^Zk_len );
% Note that kratio = cdm1/cd

% density evaluated at a single measurement
cd1 = poisspdf( 1,lambda_c)*meas.clutterpdf;

% Table for the inner products:
iptable = (repmat( w_pred, 1, Zk_len ))'.*Gk;

% inner porducts
ips = sum( iptable , 2 );

scips = P_D*sum(ips)*kratio;

this.postcard(2) = ( 1- P_D + scips )/(1/this.predcard(2) - P_D + scips );
this.postcard(1) = 1-this.postcard(2);

%disp( sprintf('The posterior cardinality sums up to %g', this.postcard(1) + this.postcard(2)));

nu_pred = sum(w_pred);

% Get new born particle weights
if ~isempty( this.nbintensity )
    nu_nb  = this.nbintensity.mu;
else
    nu_nb  = 0;
end

%Updated weights and particles
w_upd_comp = zeros(length(w_pred),Zk_len+1);

denom = 1-P_D + scips;

zcontr = sum(Gk,1)';
for i=1:Zk_len
    w_upd_comp(:,i) = P_D*( iptable(i,:)' )*kratio/denom;
end

w_upd_comp(:,Zk_len+1) = (1-P_D)/denom/length(w_pred);

% MU:
% Here we sort the contribution of each measurement to each particle and
% achieve a clustering:
[maxCont, clusterIndx] = max( w_upd_comp(:,1:Zk_len+1)' );

w_upd = sum(w_upd_comp')';

this.parlhood = cdn_pred(1)*(cd) + cdn_pred(2)*(cd)*( 1-P_D )...
    + cdn_pred(2)*exp(-lambda_c)*(cdm1)*P_D*sum(ips); % kratio*P_D*sum(ips); % the last three terms equals scips
%sum(w_upd)
%sum([0:length(cdn)-1]'.*cdn)

% resampling
hat_N_soft = sum(w_upd);
if hat_N_soft> 0.05
    persupdate = this.predintensity.s.particles;
    persupdate = persupdate.sublabels( clusterIndx );
    persupdate = persupdate.subweights( w_upd/hat_N_soft );
    
    if this.regflag
       persupdate = persupdate.updatekdebwsblabh('nonsparse');
      %persupdate = persupdate.updatekdebwsblab('nonsparse');
      %persupdate = persupdate.updatekdebws('nonsparse');
    end
    
    % Resample
    
    Lk= min(round(hat_N_soft*flt_param.rho),flt_param.Lmax);
    
    [persupdate, rind] = persupdate.resample(Lk); % Resample with the weights
    %persupdate = persupdate.mergeblab;
    if this.regflag
    persupdate = persupdate.regwkde(this.regvar);
    end
    persupdate = persupdate.inchist; % increase the history length by one
   
          
    this.postintensity = phd;
    this.postintensity.mu = hat_N_soft;
    
    this.postintensity.s.particles = persupdate;
    this.postintensity.s.kdes = [];
    this.postintensity.s.gmm = [];
    
    
else
   this.postintensity = phd;
   this.postintensity = this.postintensity([]);
    
   this.mupost = 0;
   this.postcard = [1 0 0]';
end



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
    if nargout>=2
        varargout{2} = this.parlhood;
    end
end
