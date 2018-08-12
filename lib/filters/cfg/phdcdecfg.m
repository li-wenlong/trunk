classdef phdcdecfg
    properties
        maxnumcardbins = 1200; % Maximum number of bins for the cardinality distribution
        maxnumpart = 5e4; % Max. number of particles
        numpartnewborn = 100; % Number of particles for new target candidates
        numpartpersist = 400; % Number of particles for persistent targets
        targetmodelcfg
        speedminmax = [0 45]'; % This is the limits of the uniform distribution to generate
        veldist = [];
        % Velocity components of the new born target states
        probbirth = 0.0009;
        probsurvive = 0.97;
        probdetection = 0.97;
        regflag = 1; % regularisation flag
        mcmcmoveflag = 0; % mcmc move flag
        regvar = 0; % extra noise var. added during reg
    end
     methods
        function c = phdcdecfg
            c.targetmodelcfg = stf_lingausscfg;
        end
    end
end
