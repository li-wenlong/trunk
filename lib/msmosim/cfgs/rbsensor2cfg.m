classdef rbsensor2cfg < sensorcfg
    properties
        pd = 0.95;
        maxrange = 10000;
        alpha = 30*pi/180;
        stdang = pi/180;
        stdrange = 50;        
    end
    methods
        function r = rbsensor1cfg
            r.cluttercfg = poisclut2cfg;
        end
    end
end
