classdef extsensor < sensor
    properties
        pd = 0.95,% Probability of detection
        alpha = 90*pi/180;
        maxrange
        stdang
        stdrange

        m 
        P 
        x_min 
        x_max 
        y_min 
        y_max 
        lambda 
        gamma 
        angle 
        major_axis 
        minor_axis 
        r_sig1 

    end
    methods
        function s = extsensor(varargin)
            s = s@sensor( extsensorcfg );
            if nargin>=1
                if isa( varargin{1}, 'extsensorcfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = extsensorcfg;
                s.cfg.cluttercfg = poisclut2cfg;
                s.init;
            end
        end 
    end
end
