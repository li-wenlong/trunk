function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'pf1cfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'pf1cfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

this.veldist = this.cfg.veldist;
this.maxnumpart = this.cfg.maxnumpart;
this.numpart = this.cfg.numpart;
this.regflag = this.cfg.regflag;
this.regvar = this.cfg.regvar;

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
