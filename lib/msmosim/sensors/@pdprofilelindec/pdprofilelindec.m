classdef pdprofilelindec
    properties
        cfg
        a            % a of the linear decay -ar+b
        b            % b of the linear decay -ar+b
        pdfar        % pd over the uniform portion
        pdnear       % average pd over the lin decay region
        threshold    % range threshold beyond which a uniform distr. is used.
        range
    end
     methods
        function c = pdprofilelindec( varargin )
          if nargin>=1
                if isa( varargin{1}, 'pdprofilelindeccfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = pdprofilelindeccfg;
                c.init;
           end 
        end
        
    end
end
