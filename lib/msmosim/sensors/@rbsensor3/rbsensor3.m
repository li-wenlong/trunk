classdef rbsensor3 < sensor
    properties
        pdprofile  % Probability of detection
        alpha 
        maxrange
        stdang
        stdrange
    end
    methods
        function s = rbsensor3(varargin)
            s = s@sensor( rbsensor3cfg );
            if nargin>=1
                if isa( varargin{1}, 'rbsensor3cfg' )
                    % initialize with this config                  
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = rbsensor3cfg;
                s.cfg.cluttercfg = poislindeclutcfg;
                s.cfg.pdprofilecfg = pdprofilelindeccfg;
                s.init;
            end
        end 
    end
end
