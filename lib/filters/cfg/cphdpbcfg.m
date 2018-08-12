classdef cphdpbcfg
    properties
        maxnumcardbins = 30; % Maximum number of bins for the cardinality distribution
        maxnumpart = 5e4; % Max. number of particles
        numpartnewborn = 750; % Number of particles for new target candidates
        numpartpersist = 5000; % Number of particles for persistent targets
        targetmodelcfg
        speedminmax = [150 300]'; % This is the limits of the uniform distribution to generate
        veldist = [];
        % Velocity components of the new born target states
        probbirth = 0.009;
        probsurvive = 0.98;
        probdetection = 0.975;
    end
     methods
        function c = cphdpbcfg
            c.targetmodelcfg = stf_lingausscfg;
        end
    end
end