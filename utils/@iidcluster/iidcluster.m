classdef iidcluster
    properties
        card % scale factor 
        s  % localisation density
    end
    methods
        function i = iidcluster(varargin)
            if nargin>=1
                if isa( varargin{1}, 'iidclustercfg' )
                    % initialize with this config
                    i.iidclustercfg( varargin{1} );
                else
                    error('Unknown variable input!');
                end
            else
                i.init( iidclustercfg );
            end
        end
    end
end
    
