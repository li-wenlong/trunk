classdef stf_recordedcfg 
    properties
        rectrack = treport;
    end
    methods
        function s = stf_recordedcfg( varargin )
            trep = treport;
            trep.time = 0;
            trep.state = kstate;
            s.rectrack = trep;

         end
    end
end
