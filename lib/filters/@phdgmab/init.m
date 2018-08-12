function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'phdgmabcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'phdgmabcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.veldist = this.cfg.veldist;
this.maxnumcomp = this.cfg.maxnumcomp;
this.numcompnewborn = this.cfg.numcompnewborn;
this.numcomppersist = this.cfg.numcomppersist;
this.probbirth = this.cfg.probbirth;
this.probsurvive = this.cfg.probsurvive;
this.probdetection = this.cfg.probdetection;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_max = this.cfg.maxnumcardbins;


%-------------------------------------

cdn =  [1;zeros(N_max,1)];   % cardinality distribution;
cdn_nb = poisspdf([0:N_max], this.probbirth )'; % Nearly a dirac delta
this.munb = this.probbirth;

this.postcard = cdn;
this.mupost = 0;
this.cardnb = cdn_nb;

this.nbintensity = phd;
this.nbintensity = this.nbintensity([]);
this.predintensity = this.nbintensity;
this.postintensity = this.nbintensity;
this.confintensity = this.nbintensity;

this.sumdenum = 0;
this.proddenum = 1;

if isa( this.cfg.targetmodelcfg, 'stf_lingausscfg' )
    this.targetmodel = stf_lingauss( this.cfg.targetmodelcfg );
elseif isa( this.cfg.targetmodelcfg, 'stf_lingauss2cfg' )
    this.targetmodel = stf_lingauss2( this.cfg.targetmodelcfg );
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
