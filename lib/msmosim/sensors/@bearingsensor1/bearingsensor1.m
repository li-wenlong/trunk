classdef bearingsensor1 < sensor
    properties
        pd;% Probability of detection
        alpha;
        minrange;
        maxrange;
        stdang;
        stdoneorange;
        meanoneorange;
    end
    methods
        function s = bearingsensor1(varargin)
            s = s@sensor( bearingsensor1cfg );
            if nargin>=1
                if isa( varargin{1}, 'bearingsensor1cfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = bearingsensor1cfg;
                s.cfg.cluttercfg = poisclut2cfg;
                s.init;
            end
        end 
    end
end
