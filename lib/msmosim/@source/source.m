classdef source
    properties
        ID
        cfg
        time
        location
        orientation
        velocity
        velearth
        band
        power
        detwone
    end
    methods
        function s = source( varargin)
            if nargin>=1
                if isa( varargin{1}, 'sourcecfg' )
                    % initialize with this config
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = sourcecfg;
                s.init;
            end
        end
        
    end
end
