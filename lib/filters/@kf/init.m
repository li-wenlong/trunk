function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'kfcfg' )
        error('Unknown configuration object!');
    end
    this.cfg = cfg;
else
    if ~isa( this.cfg, 'kfcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end


if isa( this.cfg.targetmodelcfg, 'stf_lingausscfg' )
    this.targetmodel = stf_lingauss( this.cfg.targetmodelcfg );
else
    error('Unidentified target model');
end
this.veldist = cfg.veldist;
this.initstate = cfg.initstate;
this.pred = cfg.pred;
this.post = cfg.post;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
