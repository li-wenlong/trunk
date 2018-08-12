classdef sequnbiascfg
    properties
        numparticles = 500;
        rangebnd = 500;
        bearingbnd = 10*pi/180;
        rangeratebnd = 200;
        
        rangevar = (500/3)^2;
        bearingvar = (10*pi/180/3)^2;
        rangeratevar = (200/3)^2;
        
        mt = 'uniform'; % Markov Transition
        
        rangeshiftbnd = 50;
        bearingshiftbnd = 2*pi/180;
        rangerateshiftbnd = 75;
        
        rangeshiftvar = (100/3)^2;
        bearingshiftvar = (2*pi/180/3)^2;
        rangerateshiftvar = (40/3)^2;
        filtercfg = phdmcabcfg;
    end
end
