classdef rbsensor1cfg < sensorcfg
    properties
        pd = 0.95;
        maxrange = 10000;
        stdang = pi/180;
        stdrange = 50;        
    end
    methods
        function r = rbsensor1cfg
            r.cluttercfg = poisclut1cfg;
        end
    end
end