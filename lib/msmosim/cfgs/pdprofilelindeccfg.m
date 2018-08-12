classdef pdprofilelindeccfg
    properties
        pdatzero  = 0.95;      % Expected number of returns in the decay region
        pdfar     = 0.9;      % Expected number of returns from the uniform region
        range     = 10000;
        threshold = 500;   % range threshold beyond which a uniform distr. is used.
    end
end
