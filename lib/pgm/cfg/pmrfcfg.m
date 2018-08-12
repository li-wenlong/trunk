classdef pmrfcfg < ugcfg
    properties
        mschedule
        uschedule % update schedule
        euschedule % edge potential update schedule
        itermax
        nodes = [];
        edgepots
    end
    methods
        function g = pmrfcfg
            g.V = [1,2];
            g.E = [[1,2];[2 1]];
            g.mschedule =  {[[1,2];[2 1]]} ; % Messaging schedule
            g.uschedule = cell(0);
            g.euschedule = cell(0);
            g.nodes = [nodecfg, nodecfg];
            g.edgepots = [edgepotcfg,edgepotcfg];
        end
    end
end
