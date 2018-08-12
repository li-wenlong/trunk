classdef linobs < sensor
    properties
        pd = 0.95,% Probability of detection
        maxrange
        minrange
        alpha
        statelabels;
        linTrans
        noiseCov
    end
    methods
        function s = linobs(varargin)
            s = s@sensor( linobscfg );
            if nargin>=1
                if isa( varargin{1}, 'linobscfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = linobscfg;
                s.cfg.cluttercfg = poisclut1cfg;
                s.init;
            end
        end 
    end
end
