 function varargout = init( this, varargin )
 
 
 if nargin>=2
     cfg = varargin{1};
     if ~isa( cfg, 'msmosimcfg' )
         error('Unknown configuration object!');
     end
     this.cfg = cfg;
 else
     if ~isa( this.cfg, 'msmosimcfg' )
         error('Unknown configuration object provided!');
     end
     cfg = this.cfg;
 end
 this.objcnt  = 0;
 % Init the platforms
 for i=1:length( cfg.platformcfgs )
     this.objcnt = this.objcnt + 1;
     
     plt = platform;
     plt.cfg = cfg.platformcfgs{i};
     plt = plt.init;
     
     this.lints(i,:) = [plt.gett0, plt.gettf];
     
     plt.setID( this.objcnt );
     this.platforms{i} = plt;
     
     
     % Get the life span of the platform
     
     % 
     
 end
 
this.time = cfg.tstart; 
this.deltats = cfg.deltat;
this.itercnt = 0;
this.deltat = this.deltats(1);

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end