classdef poislindeclut
    properties
        cfg
        a            % a of the linear decay -ar+b
        b            % b of the linear decay -ar+b
        lambdaou     % lambda (intensity) over the uniform portion
        lambdaod     % lambda over the lin decay region
        intun        % Intensity over the uniform region
        intatzero    % Intensity at range, r = 0
        threshold    % range threshold beyond which a uniform distr. is used.
        range
    end
     methods
        function c = poislindeclut( varargin )
          if nargin>=1
                if isa( varargin{1}, 'poislindeclutcfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = poislindeclutcfg;
                c.init;
           end 
        end
        
    end
end
