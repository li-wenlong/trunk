classdef trackgen1cfg
    properties
        alpha = 0.1;
        beta = 1;
        targetmodelcfg
    end
      methods
        function c = trackgen1cfg
            c.targetmodelcfg = stf_lingausscfg;
        end
    end
end