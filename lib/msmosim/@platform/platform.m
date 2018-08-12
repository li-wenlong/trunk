classdef platform
    properties
        cfg 
        ID
        state
        statelabels
        stfswitch = [0,100]';
        stfs = {'identity','die'};
        stfcfgs = {stf_identitycfg, stf_diecfg};
        stfobjs = {};
        crrntstfnum = [1];
        sources 
        sensors
        track
    end
    
    methods
        % Constructor
        function p = platform( varargin )
            p.track = track;
            if nargin>=1
                cfg = varargin{1};
                if ~isa( cfg,'platformcfg' )
                    error('Unknown configuration object!');
                end
            else
                cfg = platformcfg;
            end
            p = p.init( cfg );
        end
        function st = gett0( this )
            st = this.stfswitch(1);
        end
        function et = gettf( this )
            et = realmax;
            for i=1:length( this.stfs  )
               if strcmp('die', this.stfs{i}) 
                  et = this.stfswitch(i);
                  return;
               end
            end
        end
        function rflag = delete(this, p )
           rflag = 1; 
        end
    end
end
            
        