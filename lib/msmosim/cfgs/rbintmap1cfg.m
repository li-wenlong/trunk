classdef rbintmap1cfg < sensorcfg
    properties
        minrange = 1000; % The four parameters specifying the field of fiew
        maxrange = 4000;
        minalpha = -pi*30/180;
        maxalpha =  pi*30/180;
        deltarange = 10;% range resolution
        deltabearing = 1*pi/180;% Bearing angle resolution
        dwelltime = 0.1;
        betasquare = 0.1; % Complex noise power
        signalpower = 1; % Complex signal power
    end
    methods
        function e = rbintmap1cfg
           e.betasquare = 1.0;
        end
    end
end
