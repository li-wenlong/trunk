function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'jottmcabcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'jottmcabcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.speedminmax = this.cfg.speedminmax;
this.veldist = this.cfg.veldist;
this.maxnumpart = this.cfg.maxnumpart;
this.numpartnewborn = this.cfg.numpartnewborn;
this.numpartpersist = this.cfg.numpartpersist;
this.probbirth = this.cfg.probbirth;
this.probsurvive = this.cfg.probsurvive;
this.probdetection = this.cfg.probdetection;
this.regflag = this.cfg.regflag;
this.regvar = this.cfg.regvar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_max = this.cfg.maxnumcardbins;
% ----  precalculate values of P(n,j) and C(n,j)
logCcoef = zeros(N_max+1,N_max+1);
logPcoef = zeros(N_max+1,N_max+1);
% this will list all logfactorials for n=0,1,2,...N_max
logfactorial = zeros(N_max+1,1);
logfactorial(1) = 0;
for n=1:N_max
    logfactorial(n+1) = log(n)+logfactorial(n);
end

for ell=0:N_max
    for j=0:ell
        logPcoef(ell+1,j+1) = logfactorial(ell+1)-logfactorial(ell-j+1);
        logCcoef(ell+1,j+1) = logPcoef(ell+1,j+1)-logfactorial(j+1);
    end
end
%---- end calculations for P(n,j) and C(n,j)

%-------------------------------------

cdn =  [1;zeros(N_max,1)];   % cardinality distribution;
cdn_nb = poisspdf([0:N_max], this.probbirth )'; % Nearly a dirac delta


this.logPcoef = logPcoef;
this.logCcoef = logCcoef;
this.logfactorial = logfactorial;

this.postcard = cdn;
this.cardnb = cdn_nb;

if isa( this.cfg.targetmodelcfg, 'stf_lingausscfg' )
    this.targetmodel = stf_lingauss( this.cfg.targetmodelcfg );
else
    error('Unidentified target model');
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
