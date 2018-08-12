classdef phdmcintmap1 % PHD filter implemented using (Sequential) Monte Carlo
                  % with adaptive birth process
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        speedminmax
        veldist
        regflag;
        regvar;
        mcmcmoveflag;
        maxnumpart
        numpartnewborn
        numpartpersist
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
    properties ( SetAccess = private )
        logPcoef
        logCcoef
        logfactorial
    end
       
    methods
        function cf = phdmcintmap1(varargin)
            if nargin>=1
                if isa( varargin{1}, 'phdmcintmap1cfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = phdmcintmap1cfg;
                cf.init;
            end
        end
    end
end
        
