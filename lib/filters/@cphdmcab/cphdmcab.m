classdef cphdmcab % CPHD filter implemented using (Sequential) Monte Carlo
                  % with adaptive birth process
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        speedminmax
        veldist
        maxnumpart
        regflag
        regvar
        numpartnewborn
        numpartpersist
        probbirth
        probsurvive
        probdetection
	    cardnb
        nbintensity
        predintensity
        predcard
        postintensity
        postcard
        predintbuffer
        predcardbuffer
        postintbuffer
        postcardbuffer
        mslabels = [];
        resindx = [];
    end
    properties ( SetAccess = private )
        logPcoef
        logCcoef
        logfactorial
        Pcoef
        factor
    end
       
    methods
        function cf = cphdmcab(varargin)
            if nargin>=1
                if isa( varargin{1}, 'cphdmcabcfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = cphdmcabcfg;
                cf.init;
            end
        end
    end
end
        
