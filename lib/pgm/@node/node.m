classdef node
    properties
        cfg
        id
        parents
        children
        state
        dim
        nestates
        nodemeas
        initstate
        noisedist      % This is the Gaussian object for the noise distribution
        C             % this is the measurement transform y = Cx+n
        y
        ydim
        edgepotentials
        epotobjs
        iternum
        inbox
        previnbox
        outbox
        inboxlog
        previnboxlog
        outboxlog
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function o = node(varargin)
          if nargin>=1
                if isa( varargin{1}, 'nodecfg' )
                    % initialize with this config
                    o.init( varargin{1} );
                elseif isempty(  varargin{1} )
                    o = node;
                    o = o([]);
                else
                    error('Unknown variable input');
                end
          else
                o.cfg = nodecfg;
                o.init;
           end 
        end
        
    end
end
