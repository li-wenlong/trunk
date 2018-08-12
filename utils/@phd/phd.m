classdef phd
    properties
        mu % scale factor 
        s  % localisation density
    end
    methods
        function i = phd(varargin)
            if nargin>=1
                if isa( varargin{1}, 'phdcfg' )
                    % initialize with this config
                    i.init( varargin{1} );
                elseif isempty( varargin{1} )
                    i = i([]);
                else
                    error('Unknown variable input');
                end
            else
                i.init( phdcfg );
            end
        end
    end
end
    
