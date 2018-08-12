classdef phdmcintmap1cfg
    properties
        maxnumcardbins = 30; % Maximum number of bins for the cardinality distribution
        maxnumpart = 5e6; % Max. number of particles
        numpartnewborn = 4; % Number of particles for new target candidates
        numpartpersist = 300; % Number of particles for persistent targets
        targetmodelcfg
        speedminmax = [5 30]'; % This is the limits of the uniform distribution to generate
        veldist = [];
        % Velocity components of the new born target states
        probbirth = 0.00009;
        probsurvive = 0.98;
        regflag = 1; % regularisation flag
        mcmcmoveflag = 0; % mcmc move flag
        regvar = 0; % extra noise var. added during reg
    end
     methods
        function c = phdmcintmap1cfg
            c.targetmodelcfg = stf_lingausscfg;
        end
    end
end
