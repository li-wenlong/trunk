classdef kstate
     properties
        state = [0 0]';
        statelabels = {'x','y'}; % This is what we want get by getState
     end
    properties %( SetAccess = private )
        location = [0 0 0]'; % Location in Earth fixed coordinate system
        velocity = [0 0 0]'; % Velocity in Platform coordinate system
        acceleration = [0 0 0]'; % This is what drives linear motion
        orientation = [0 0 0]'; % Euler angles from Earth fixed frame to platform frame
        angularvelocity = [0 0 0]'; % Angular velocities in platform frame
        angularmoment = [0 0 0]';   % This is what drives angular motion
    %    orientationrate = [0 0 0]'; 
        velearth = [0 0 0]';
        accelearth = [0 0 0]';   
    end
    methods
        function k = kstate( varargin )
            if nargin>=1
                labels = varargin{1};
                k = k.setstatelabels( labels );
                if nargin>=2
                    nstate = varargin{2};
                    k = k.substate( nstate ); % Substitute into the state variables
                    k.catstate; % Concat the state
                end
            end
            
        end
        
    end
    
    
end
