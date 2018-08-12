classdef gmrfcfg < ugcfg
    properties
        mschedule
        nodes = [];
        edgepotentials = [];
    end
    methods
        function g = gmrfcfg
            g.V = [1,2];
            g.E = [[1,2];[2 1]];
            g.mschedule =  {[[1,2];[2 1]]} ; % Messaging schedule
            g.nodes = [nodecfg, nodecfg];
            g.edgepotentials = cpdf( [gk,gk] );
        end
    end
end
