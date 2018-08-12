classdef stf_recorded < stf_nonlin1
    properties
         rectrack;
    end
    methods
        function s = stf_recorded( varargin )
            %s = s@stf_nonlin1( stf_nonlin1cfg );
            if nargin>=1
                if isa( varargin{1}, 'stf_recordedcfg' )
                    % initialize with this config
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = stf_recordedcfg;
                s.init;
            end
        end % stf_recorded end        
    end % methods end
end
        
