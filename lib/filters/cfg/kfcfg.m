classdef kfcfg
    properties
        targetmodelcfg
        veldist  % Velocity components of the new born target states
        initstate 
        post
        pred
    end
     methods
        function c = kfcfg
            c.targetmodelcfg = stf_lingausscfg;
            c.post = gk([]);
            c.pred = gk([]);
        end
    end
end
