classdef rbrrsensor1cfg < sensorcfg
    properties
        pd = 0.95;
        maxrange = 10000;
        maxvel = 250;
        alpha = 30*pi/180;
        stdang = pi/180;
        stdrange = 50;
        stdrangerate = 5;        
    end
    methods
        function r = rbrrsensor1cfg
            r.cluttercfg = poisclut2cfg;
        end
    end
end
