classdef poislldclut
    properties
        cfg
        lldeca       % a of the log linear decay exp(-a(r-r0)+b)
        lldecb       % b of the log linear decay exp(-a(r-r0)+b)
        lambdaou     % lambda (intensity) over the uniform portion
        lambdaod     % lambda over the log-lin decay region
        intun        % Intensity over the uniform region
        intatzero    % Intensity at range, r = 0
        threshold    % range threshold beyond which a uniform distr. is used.
        range
    end
     methods
        function c = poislldclut( varargin )
          if nargin>=1
                if isa( varargin{1}, 'poislldclutcfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = poislldclutcfg;
                c.init;
           end 
        end
        
    end
end
