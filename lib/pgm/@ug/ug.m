classdef ug
    properties
        cfg
        nodes % Variable node objects
        edgepots % Edge potential objects
        V % list of node ids
        E % List of edges        
        N % number of nodes
        M % number of edges
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function o = ug(varargin)
            if nargin>=1
                if isa( varargin{1}, 'ugcfg' )
                    % initialize with this config
                    myugcfg = varargin{1};
                else
                    error('Unknown variable input');
                end
            else
                myugcfg =  ugcfg;
            end
            o = o.init( myugcfg );
        end
        
    end
end
