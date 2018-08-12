classdef phdgmabcfg
    properties
        maxnumcardbins = 100; % Maximum number of bins for the cardinality distribution
        maxnumcomp = 1000; % Max. number of gaussian components
        numcompnewborn = 100; % Number of gaussian components for new target candidates
        numcomppersist = 1000; % Number of particles for persistent targets
        targetmodelcfg
        veldist;
        % Velocity components of the new born target states
        probbirth = 0.0001;
        probsurvive = 0.98;
        probdetection = 0.99;
    end
     methods
        function c = phdgmabcfg
            c.targetmodelcfg = stf_lingausscfg;
            c.veldist = gmm(1',gk( [10^2 0;0 10^2], [ 0 0]'));
        end
    end
end
