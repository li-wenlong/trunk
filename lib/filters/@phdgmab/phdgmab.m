classdef phdgmab % PHD filter implemented using Gaussian mixtures
                  % with adaptive birth process
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        veldist         % Distribution of the velocity dimension
        maxnumcomp      % Maximum number of components
        numcompnewborn  % Number of components for the birth process
        numcomppersist  % Number of components for the persistent bit
        probbirth
        probsurvive
        probdetection
        munb
        cardnb
        nbintensity
        predintensity
        mupred
        predcard
        postintensity
        mupost
        postcard
        confintensity
        sumdenum
        proddenum
        parlhood % Parent likelihood
        parloglhood % log likelihood
        predintbuffer
        predcardbuffer
        postintbuffer
        postcardbuffer
        infobuffer
    end
    
       
    methods
        function cf = phdgmab(varargin)
            if nargin>=1
                if isa( varargin{1}, 'phdgmabcfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = phdgmabcfg;
                cf.init;
            end
        end
    end
end
        
