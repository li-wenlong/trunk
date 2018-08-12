classdef statetranscfg
    properties
        switchtimes = [0,100];
        transfunc = {'identity','die'};
        transfunccfg = { stf_identitycfg, stf_diecfg };
    end
end