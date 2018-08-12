classdef pf1cfg
    properties
        maxnumpart = 5e4; % Max. number of particles
        numpart = 1000; % Number of particles for new target candidates
        targetmodelcfg
        veldist = []; % Velocity components of the new born target states
        regflag = 1; % regularisation flag
        regvar = 0; % extra noise var. added during reg
    end
     methods
        function c = pf1cfg
            c.targetmodelcfg = stf_lingausscfg;
        end
    end
end
