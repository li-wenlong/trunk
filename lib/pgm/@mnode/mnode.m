classdef mnode
    properties
        cfg
        id
        children
        lhood
        Z
        state
        iternum
        inbox
        outbox
        inboxlog
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
