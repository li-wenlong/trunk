classdef platformcfg 
    properties
        statelabels = {'x','y'};
        state = [0 0]';
        stfswitch = [0,100]';
        stfs = {'identity','die'};
        stfcfgs = {stf_identitycfg, stf_diecfg};
        sourcecfgs
        sensorcfgs 
    end
end
        