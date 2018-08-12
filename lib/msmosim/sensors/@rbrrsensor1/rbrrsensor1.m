classdef rbrrsensor1 < sensor
    properties
        pd = 0.95,% Probability of detection
        alpha = 30*pi/180;
        maxrange
        maxvel
        stdang
        stdrange
        stdrangerate
    end
    methods
        function s = rbrrsensor1(varargin)
            s = s@sensor( rbrrsensor1cfg );
            if nargin>=1
                if isa( varargin{1}, 'rbrrsensor1cfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = rbrrsensor1cfg;
                s.cfg.cluttercfg = poisclut2cfg;
                s.init;
            end
        end 
    end
end
