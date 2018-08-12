classdef bearingsensor1cfg < sensorcfg
    properties
        pd = 0.95;
        alpha = pi/2 ;
        minrange = 100;
        maxrange = 10000;
        stdang = pi/180;
    end
    methods
        function r = rbsensor1cfg
            r.cluttercfg = poisclut1cfg;
        end
    end
end
