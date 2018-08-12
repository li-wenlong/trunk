classdef gmrf < ug
    properties
        % nodes % Variable node objects
        mschedule %messaging schedule
        iternum
        itermax
        dims
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function o = gmrf(varargin)
            
            disp('inside gmrf constructor' );
            if nargin>=1
                if isa( varargin{1}, 'gmrfcfg' )
                    % initialize with this config
                    mygmrfcfg = varargin{1};
                    
                else
                    error('Unknown variable input');
                end
            else
                
                mygmrfcfg = gmrfcfg;
                
                mynodecfg1 = mygmrfcfg.nodes(1);
                mynodecfg1.state = cpdf( gk );
                mygmrfcfg.nodes(1) = mynodecfg1;
                
                mynodecfg1 = mygmrfcfg.nodes(2);
                mynodecfg1.state = cpdf( gk );
                mygmrfcfg.nodes(2) = mynodecfg1;
            end
            %
            o = o@ug( mygmrfcfg ); % This prevents an empty call to the ug constructor
            % The init method is called within the base class constructor
           
        end
    end
end
