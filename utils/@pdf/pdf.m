classdef pdf
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
         function d = pdf(varargin)
            if nargin>=1
                if isa( varargin{1}, 'pdfcfg' )
                    % initialize with this config
                    d.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                d.init( pdfcfg );
            end
        end        
    end
end
    
