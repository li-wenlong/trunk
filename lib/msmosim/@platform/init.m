function varargout = init( this, varargin )

if nargin>=2
    cfg = varargin{1};
    if ~isa( cfg, 'platformcfg' )
        error('Unknown configuration object!');
    end
else
    if ~isa( this.cfg, 'platformcfg' )
        error('Unknown configuration object provided!');
    end
    cfg = this.cfg;
end

% init the stfs
for i = 1:length( cfg.stfcfgs )
    
    if isa( cfg.stfcfgs{i}, 'stf_recordedcfg' )
        cfg.statelabels = cfg.stfcfgs{i}.rectrack(1).state.statelabels;
        cfg.state = cfg.stfcfgs{i}.rectrack(1).state.state;
       % cfg.stfswitch(1) = cfg.stfcfgs{i}.rectrack(1).time;
        
    else
        
        cfg.stfcfgs{i}.statelabels = cfg.statelabels;
        cfg.stfcfgs{i}.state = cfg.state;
        if i == 1
            cfg.stfcfgs{i}.state = cfg.state;
            cfg.stfcfgs{i}.inittime = cfg.stfswitch(1);
        end
    end
    
    if isa( cfg.stfcfgs{i}, 'stf_identitycfg' )
        this.stfobjs{i} = stf_identity( cfg.stfcfgs{i}  ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_diecfg' )
        this.stfobjs{i} = stf_die( cfg.stfcfgs{i}  ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_lingausscfg' )
        this.stfobjs{i} = stf_lingauss( cfg.stfcfgs{i} ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_lingauss2cfg' )
        this.stfobjs{i} = stf_lingauss2( cfg.stfcfgs{i} ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_circmotioncfg' )
        this.stfobjs{i} = stf_circmotion( cfg.stfcfgs{i} ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_nonlin1cfg' ) % This type has to be at the end since most of those
        % up inherit from this one
        this.stfobjs{i} = stf_nonlin1( cfg.stfcfgs{i}  ) ;
    elseif isa( cfg.stfcfgs{i}, 'stf_recordedcfg' )
        this.stfobjs{i} = stf_recorded( cfg.stfcfgs{i}  ) ;
        
    else
        error('Unidentified state transition function class');
    end
    %      if i == 1
    %          % Init the first stf
    %          k = kstate( cfg.statelabels, cfg.state ); % This is the initial kinematic state
    %          this.stfobjs{i} = this.stfobjs{i}.setkstate( k ); % subs. the initial state in the first stf
    %          this.stfobjs{i} = this.stfobjs{i}.settime( cfg.stfswitch(1) ); % subs. the initial time
    %      end
end

this.cfg = cfg;
this.stfcfgs = cfg.stfcfgs;
this.stfswitch = cfg.stfswitch;
this.statelabels = cfg.statelabels;
this.state =  this.stfobjs{1}.state;

this.stfs = cfg.stfs;

cs = this.getkstate;
% init the sources
for i=1:length(cfg.sourcecfgs)
    if isa( cfg.sourcecfgs{i}, 'sourcecfg' )
        cfg.sourcecfgs{i}.velearth = cs.velearth;
        this.sources{i} = source( cfg.sourcecfgs{i} );
        this.sources{i} = this.sources{i}.setID(i);
    else
        error('Unidentified source class');
    end
end

% init the sensors
for i=1:length(cfg.sensorcfgs )
    if isa( cfg.sensorcfgs{i}, 'rbsensor1cfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = rbsensor1( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'rbrrsensor1cfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = rbrrsensor1( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'rbsensor2cfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = rbsensor2( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'rbsensor2bcfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = rbsensor2b( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'linobscfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = linobs( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'extsensorcfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = extsensor( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'bearingsensor1cfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = bearingsensor1( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'eosensorcfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = eosensor( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    elseif isa( cfg.sensorcfgs{i}, 'rbintmap1cfg' )
        cfg.sensorcfgs{i}.velearth = cs.velearth;
        
        this.sensors{i} = rbintmap1( cfg.sensorcfgs{i} );
        this.sensors{i} = this.sensors{i}.setID(i);
    else
        error('Unidentified sensor class');
    end
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

