classdef rbsensor2 < sensor
    properties
        pd = 0.95,% Probability of detection
        alpha = 30*pi/180;
        maxrange
        stdang
        stdrange
    end
    methods
        function s = rbsensor2(varargin)
            s = s@sensor( rbsensor2cfg );
            if nargin>=1
                if isa( varargin{1}, 'rbsensor2cfg' )
                    % initialize with this config                  
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = rbsensor2cfg;
                s.cfg.cluttercfg = poisclut2cfg;
                s.init;
            end
        end 
    end
end
