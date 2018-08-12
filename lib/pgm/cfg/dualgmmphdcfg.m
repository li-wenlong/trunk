classdef dualgmmphdcfg < edgepotcfg
    properties
        T       % Time axis for the post/pred containers below
        predis  % prediction disttributions of node i 
        predjs  % prediction distributions of node j
        filteri % filter configuration at node i
        filterj % filter configuration for node j
        sensoricfg % sensor config object for i encapsulating H_i and R_i of the linear observation model
        sensorjcfg % sensor config object for sensor j 
        sensorbufferi % This is the measurement buffer of sensor ithat will be taken into account
        sensorbufferj % sensor j's measurement buffer
    end
    methods
        function q = dualgmmphdcfg
           q = q@edgepotcfg;
           q.initgenfun = @initthetas;
           q.dim = 2;
           q.labels = {'x','y'};
           q.limits = [-1000 1000 -1000 1000];
           q.T = [1 2]; % This is the time axis for the entries below
           myphdcfg = phdcfg;
           myphdcfg.scfg.gmm = gmm;
           myphd = phd( myphdcfg );
           q.filteri = phdgmabcfg;
           q.filterj = phdgmabcfg;
           q.predis = {     phd([]), myphd };% prediction disttributions of node i 
           q.predjs = {     phd([]), myphd }; % prediction distributions of node j
           q.sensoricfg = linobscfg; % sensor object encapsulating H_i and R_i of the linear observation model
           q.sensorjcfg = linobscfg; % sensor object encapsilating H_j and R_j of the linear observation model
           q.sensorbufferi = sreport([]); % This is the measurement buffer of sensor ithat will be taken into account
           q.sensorbufferj = sreport([]); % sensor j's measurement buffer
        end
    end
end
