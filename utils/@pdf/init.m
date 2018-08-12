function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'pdfcfg' )
        error('Unknown configuration object!');
    end
else
    cfg = pdfcfg;
end

this.kerneltype = cfg.kerneltype;
this.bwselection = cfg.bwselection;

% If particles exist
if ~isempty( cfg.particles)
    this.particles = cfg.particles;
    if ~isempty(this.particles.bws )
        this.particles = this.particles.kdebws('nonsparse');
    end
   % this.kdes = kde( this.particles.states, this.particles.bws, ...
   %     this.particles.weights', this.kerneltype );
    
    this.gmm = this.particles.par2gmm;
    
   
elseif ~isempty( cfg.gmm )
    this.gmm = cfg.gmm;
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