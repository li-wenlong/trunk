function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'eosensorcfg' )
        error('Unknown configuration object!');
    end
else
    if ~isa( this.cfg, 'eosensorcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end


this.time = cfg.inittime;
this.location = cfg.location(:);
this.orientation = cfg.orientation(:);
this.velearth = cfg.velearth(:);
this.srcbuffer = {};% source buffer
this.srbuffer = {} ;% Sensor report buffer



this.maxrange = cfg.maxrange;
this.minrange = cfg.minrange;
this.ipheight = cfg.ipheight;
this.ipwidth = cfg.ipwidth;
this.numrows = cfg.numrows; % Resolution in the horizontal direction
this.numcols = cfg.numcols; % Resolution in the vertical direction  

this.pixwidth = this.ipwidth/this.numcols;
this.pixheight = this.ipheight/this.numrows;

this.F = cfg.F;
this.S2 = cfg.S2;
% compute the field of views
%this.verfov = 2*atan2( this.ipheight/2, abs( this.S2 - this.F) );
%this.horfov = 2*atan2( this.ipwidth/2, abs( this.S2 - this.F ) );            
this.verfov = 2*atan2( this.ipheight/2, this.S2 );
this.horfov = 2*atan2( this.ipwidth/2, this.S2  );            


%this.horfov = cfg.horfov; % Horizontal field of view
%this.verfov = cfg.verfov; % Vertical field of view

this.stdanghor = cfg.stdanghor; % standard deviation in the horizontal direction
this.stdangver = cfg.stdangver; % standard deviation in the vertical direction

if isa( cfg.pdprofilecfg, 'pdprofilelindeccfg' )
    cfg.pdprofilecfg.range = this.maxrange*5;
    
    this.pdprofile = pdprofilelindec( cfg.pdprofilecfg );    
else
    error(sprintf('Unknown pd profile %s',class(cfg.pdprofilecfg)) );
end

if isa( cfg.cluttercfg, 'noclutcfg' )
    this.clutter = noclut;
elseif isa( cfg.cluttercfg, 'poisclut1cfg' )
    this.clutter = poisclut1(cfg.cluttercfg );
elseif isa( cfg.cluttercfg, 'eobinomclutcfg' )
    cfg.cluttercfg.n = this.numrows*this.numcols;
   
    this.clutter = eobinomclut(cfg.cluttercfg );
else
    error('Unknown clutter class or class not suported!')
end

this.cfg = cfg;
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


