classdef linobscfg < sensorcfg
    properties
        pd = 0.95;
        maxrange = 22000;
        minrange = 10;
        alpha = pi;
        statelabels = {'x','y'};
        linTrans = [1 0;0 1];
        noiseCov = [1 0;0 1];
    end
    methods
        function r = rbsensor1cfg
            r.cluttercfg = poisclut1cfg;
        end
    end
end