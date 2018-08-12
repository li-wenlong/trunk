function varargout = init( this, varargin )


if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'phdcfg' )
        error('Unknown configuration object!');
    end
else
    cfg = phdcfg;
end

this.mu = cfg.mu;
this.s = pdf( cfg.scfg );


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
