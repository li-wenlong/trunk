classdef jottmcab % JOTT filter implemented using (Sequential) Monte Carlo
                  % with adaptive birth process
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        speedminmax
        veldist
        regvar
        regflag
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
        parlhood
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
        function cf = jottmcab(varargin)
            if nargin>=1
                if isa( varargin{1}, 'jottmcabcfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = jottmcabcfg;
                cf.init;
            end
        end
    end
end
        
