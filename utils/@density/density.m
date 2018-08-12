classdef density
    properties  (SetAccess = private)
        kerneltype
        bwselection
    end
    properties
        particles
        kdes
        gmm
    end
    methods
         function d = density(varargin)
            if nargin>=1
                if isa( varargin{1}, 'densitycfg' )
                    % initialize with this config
                    d.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                d.init( densitycfg );
            end
        end        
    end
end
    