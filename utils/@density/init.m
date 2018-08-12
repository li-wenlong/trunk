function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'densitycfg' )
        error('Unknown configuration object!');
    end
else
    cfg = densitycfg;
end

this.kerneltype = cfg.kerneltype;
this.bwselection = cfg.bwselection;

% If particles exist
if ~isempty( cfg.particles)
    this.particles = cfg.particles;
    [this.kdes, this.gmm] = ...
        this.particles.par2kdes('kerneltype',this.kerneltype, 'bwselection', this.bwselection);
elseif ~isempty( cfg.gmm )
    this.gmm = cfg.gmm;
    [st, c1 ] = gensamples( this.gmm , 1000 );
    this.particles = particle('state',st,'label', c1 );
    this.kdes = ...
        this.particles.par2kdes('kerneltype',this.kerneltype, 'bwselection', this.bwselection,'gmm',this.gmm);
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