classdef pmrf < ug
    properties   
        mschedule %messaging schedule
        uschedule % update schedule
        euschedule % edge potential update schedule
        iternum
        itermax
        dims
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function o = pmrf(varargin)
            
            if nargin>=1
                if isa( varargin{1}, 'pmrfcfg' )
                    % initialize with this config
                    mygmrfcfg = varargin{1};
                    
                else
                    error('Unknown variable input');
                end
            else
                
                mygmrfcfg = pmrfcfg;
                
                mdist = cpdf( gk );
                
                mynodecfg1 = mygmrfcfg.nodes(1);
                mynodecfg1.state = particles('states', mdist.gensamples(1000),'labels',1 );
                mygmrfcfg.nodes(1) = mynodecfg1;
                
                mynodecfg1 = mygmrfcfg.nodes(2);
                mynodecfg1.state = particles('states', mdist.gensamples(1000),'labels',1 );
                mygmrfcfg.nodes(2) = mynodecfg1;
                
                myedgecfg = mygmrfcfg.edgepots(1);
                myedgecfg.e = [1 2];
                myedgecfg.potfun = @symedgepotsampler;
                myedgecfg.potobj = cpdf( gk( eye(2) ) );
                mygmrfcfg.edgepots(1) = myedgecfg;
                
                myedgecfg = mygmrfcfg.edgepots(2);
                myedgecfg.e = [2 1];
                myedgecfg.potfun = @symedgepotsampler;
                myedgecfg.potobj = cpdf( gk( eye(2) ) );
                mygmrfcfg.edgepots(2) = myedgecfg;
                
            end
            %
            o = o@ug( mygmrfcfg ); % This prevents an empty call to the ug constructor
            % The init method is called within the base class constructor
           
        end
    end
end
