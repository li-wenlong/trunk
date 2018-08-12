classdef rbsensor3cfg < sensorcfg
    properties
        pdprofilecfg;
        maxrange;
        alpha = 30*pi/180;
        stdang = pi/180;
        stdrange = 4;        
    end
    methods
        function r = rbsensor3cfg
            maxrange = 10000;
            ccfg = poislindeclutcfg; % Clutter config
            ccfg.range = maxrange;
             
            pcfg = pdprofilelindeccfg;
            pcfg.range = maxrange;
            
            

            r.cluttercfg = ccfg;
            r.pdprofilecfg = pcfg;
            r.maxrange = maxrange;

        end
    end
end
