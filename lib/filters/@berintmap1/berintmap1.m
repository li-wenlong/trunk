classdef berintmap1 % berintmap1 is a Bernoulli (JOTT) filter implemented using (Sequential) Monte Carlo for the range bearing intensity map sensor class rbintmap1
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        speedminmax
        veldist
        regvar
        regflag
        mcmcmoveflag
        maxnumpart
        numpartnewborn
        numpartpersist
        probbirth
        probsurvive
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
        parlhood
        parloglhood
        delE
        delbetasq
        sploglhood % This variable contains only the signal power part of the (additive) log parameter likelihood
        parloglhoodlb
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
        function cf = berintmap1(varargin)
            if nargin>=1
                if isa( varargin{1}, 'berintmap1cfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = berintmap1cfg;
                cf.init;
            end
        end
    end
end
        
