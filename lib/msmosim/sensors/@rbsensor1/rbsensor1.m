classdef rbsensor1 < sensor
    properties
        pd = 0.95,% Probability of detection
        maxrange
        stdang
        stdrange
    end
    methods
        function s = rbsensor1(varargin)
            s = s@sensor( rbsensor1cfg );
            if nargin>=1
                if isa( varargin{1}, 'rbsensor1cfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = rbsensor1cfg;
                s.cfg.cluttercfg = poisclut1cfg;
                s.init;
            end
        end 
    end
end
