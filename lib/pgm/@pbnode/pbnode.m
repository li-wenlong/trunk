classdef pbnode % particles-belief node
    properties
        cfg  % configuration in initialisation
        id   % id 
        parents 
        children
        state % This is the node belief state (particles)
        dim   % dimensionality of the state variable
        nestates
        nodemeas
        initstate % Initial state (might be empty (constant) or particles )
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
        function o = pbnode(varargin)
          if nargin>=1
                if isa( varargin{1}, 'pbnodecfg' )
                    % initialize with this config
                    o.init( varargin{1} );
                elseif isempty(  varargin{1} )
                     o.cfg = pbnodecfg;
                     o.init;
                else
                    error('Unknown variable input');
                end
          else
                o.cfg = pbnodecfg;
                o.init;
           end 
        end
        
    end
end
