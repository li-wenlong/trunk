classdef cphdmcvar % CPHD filter implemented using (Sequential) Monte Carlo
                  % with adaptive birth process. This class outputs spatial variance
                  % of the updated process.
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
        regions
        vars
        mus
    end
    properties ( SetAccess = private )
        logPcoef
        logCcoef
        logfactorial
        Pcoef
        factor
    end
       
    methods
        function cf = cphdmcvar(varargin)
            if nargin>=1
                if isa( varargin{1}, 'cphdmcvarcfg' )
                    % initialize with this config

                    cf.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                cf.cfg = cphdmcvarcfg;
                cf.init;
            end
        end
    end
end
        
