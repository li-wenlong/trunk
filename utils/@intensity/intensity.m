classdef intensity
    properties
        mu % scale factor 
        s  % localisation density
    end
    methods
        function i = intensity(varargin)
            if nargin>=1
                if isa( varargin{1}, 'intensitycfg' )
                    % initialize with this config
                    i.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                i.init( intensitycfg );
            end
        end
    end
end
    