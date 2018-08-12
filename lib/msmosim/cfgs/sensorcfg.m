classdef sensorcfg
    properties
        inittime = 0;
        location = [0 0 0]';
        orientation = [0 0 0]';
        velearth = [0 0 0]';
        detonlynear = 0;
        cluttercfg
    end
    methods
        function s = sensorcfg
           s.cluttercfg = noclutcfg; 
        end
    end
end
