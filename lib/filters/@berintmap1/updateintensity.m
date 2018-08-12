function varargout = updateintensity( this, sensor, varargin )

Z = this.Z;

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

% Likelihood function matrix
% row m is for the m th observation, col n is for the n th particle
% M is the mask for FoV
[Gk, M, ppol] = sensor.likelihood( Z, pt );
Gn = sensor.getnoisemap( Z );
Omegas = exp( log(Gk(1,:)) -log(Gk(2,:)) ); % This is the \Omega(z_c(x)|x)


mu_post_num = this.predintensity.mu*sum(Omegas.*w_pred'/sum(w_pred));
mu_post_denum = 1-this.predintensity.mu + mu_post_num;
mu_post = mu_post_num/mu_post_denum;

this.postcard(2) = mu_post;
this.postcard(1) = 1-this.postcard(2);

%Updated weights and particles
w_upd = Omegas.*w_pred'/sum(w_pred);
w_upd = mu_post*w_upd/sum(w_upd);

this.parlhood = prod(Gn(:))*( (1-this.predintensity.mu) ...
    + this.predintensity.mu*sum(Omegas.*w_pred'/sum(w_pred)));

this.sploglhood = real( log( ...
    (1-this.predintensity.mu)+ this.predintensity.mu*log( sum(Omegas.*w_pred'/sum(w_pred)) ) ) );

this.parloglhood = real( sum( log( Gn(:) ) ) + this.sploglhood );
% The real is to avoid having complex outputs due to possible negative values
% inside the second log as computation artifacts

% Compute the log likelihood gradient
[E, betasq, zk, I_1, I_0] = sensor.likelihoodgradarrays( Z, pt );

% Find gamma = \int z*I_1/I0*l_1/l_0*s_pred(x)dx
%            = \int z I_1/I_0 g_k
gm = sum( (zk).*(I_1./I_0).*Omegas'.*w_pred )/sum(w_pred);

% \int gk
int_gk = sum(Omegas.*w_pred'/sum(w_pred));

delE = -2*E*mu_post/betasq + 2*this.predintensity.mu*(gm/betasq)/mu_post_denum;

dlogl0delbsq = -prod(size(Z.Z))/betasq + sum(Z.Z(:).^2)/betasq^2;
delT = int_gk*(E^2/betasq^2)  - (2*E/betasq^2)*gm; % This is the \int del log1 - del log0 g_k

delbetasq = dlogl0delbsq + this.predintensity.mu*delT/mu_post_denum;


this.delE = delE;
this.delbetasq = delbetasq;

% resampling
hat_N_soft = sum(w_upd);
if hat_N_soft> eps
    persupdate = this.predintensity.s.particles;
    persupdate = persupdate.subweights( w_upd/hat_N_soft );
    
    if this.regflag
        persupdate = persupdate.updatekdebws('nonsparse'); % Here, the BWs are found
      %persupdate = persupdate.updatekdebwsblab('nonsparse');
      %persupdate = persupdate.updatekdebws('nonsparse');
    end
    
    % Resample
    Lk= min( flt_param.rho, flt_param.Lmax);
    
    [persupdate, rind] = persupdate.resample(Lk); % Resample with the weights
    %persupdate = persupdate.mergeblab;
    if this.regflag
    persupdate = persupdate.regwkde(this.regvar,'dims',[1,2]);
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
