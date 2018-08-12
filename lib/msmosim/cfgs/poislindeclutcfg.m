classdef poislindeclutcfg
    properties
        lambdaod  = 10;      % Expected number of returns in the decay region
        lambdaou  = 15;      % Expected number of returns from the uniform region
        range = 10000;
        threshold = 500;   % range threshold beyond which a uniform distr. is used.
    end
end
