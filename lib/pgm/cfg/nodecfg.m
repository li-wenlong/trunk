classdef nodecfg
    properties
        id = 1;
        parents = [];
        children = [];
        neighbours = [];
        iternum = 0;
        state = []; % initial node state (density)
        noisedist = []; % noise distribution for the measurement linked to the node
        edgepotentials = []; % edge potentials (over the edges towards the children)
        epotobjs % If edgepotentials are function pointers, then epotsobjs maintain the objects to pass onto them
        C = [];
    end
end
