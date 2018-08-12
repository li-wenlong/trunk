classdef edgepotcfg
    properties
        e           % (i,j) pair of the edge as its identifier
        thetas      % points at which the potential is evaluated, initially
        numthetas   % number of these points
        dim         % dimensionality of thetas
        labels      % labels of the fields of thetas
        limits      % limits of these fields
        initgenfun  % function to generate initial values of thetas
        logpsis
        psis 
        potfun
        potobj
        updatefun
        updateparams
    end
    methods
        function e = edgepotcfg
            e.e = [1,2];
            
            e.potfun = @symedgepotsampler;
        end
    end
end