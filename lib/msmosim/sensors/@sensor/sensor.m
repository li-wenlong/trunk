classdef sensor
    properties
        ID
        cfg
        time
        location
        orientation
        velearth
        detonlynear
        clutter
        insensorframe = 0;
        srcbuffer % source buffer
        srbuffer % Sensor report buffer
    end
    methods
        function s = sensor(varargin)
            if nargin>=1
                if isa( varargin{1}, 'sensorcfg' )
                    % initialize with this config
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = sensorcfg;
                s.cfg.cluttercfg = noclutcfg;
                s.init;
            end
        end
    end
end
