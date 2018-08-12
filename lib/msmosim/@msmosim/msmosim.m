classdef msmosim
    properties
        cfg % 
        platforms % Platforms
        actplats % Ptrs to active platforms
        lints % life intervals of the platforms
        time
        deltat % current time step length
        deltats % observation collection intervals as an array
        itercnt % iteration count
        actplatsbuffer   
    end
    properties ( SetAccess = protected )
        objcnt = 0;
    end
    methods
        function m = msmosim( varargin )
            if nargin>=1
                cfg = varargin{1};
                if ~isa( cfg,'msmosimcfg' )
                    error('Unknown configuration object!');
                end
            else
                cfg = msmosimcfg;
            end
            m = m.init( cfg );  
        end
        
    end
end
    
