% STF_NONLIN1 6 DOF Euler Angle motion model for a unit mass, 
% symmetric rigid object

% Murat Uney
classdef stf_nonlin1
    properties
        cfg
        state = [0 0]';
        statelabels = {'x','y'}; % This is what we want get by getState
        deltat = 0.01;
    end
    properties( SetAccess = protected )
        location = [0 0 0]'; % Location in Earth fixed coordinate system
        velocity = [0 0 0]'; % Velocity in Platform coordinate system
        acceleration = [0 0 0]'; % This is what drives linear motion
        orientation = [0 0 0]'; % Euler angles from Earth fixed frame to platform frame
        angularvelocity = [0 0 0]'; % Angular velocities in platform frame
        angularmoment = [0 0 0]';   % This is what drives angular motion
        velearth = [0 0 0]';
        accelearth = [0 0 0]';
        % orientationrate = [0 0 0]';
        Inertia = eye(3);
        Idot = zeros(3,3);
        
        
        time = 0;
        
        i1 = integrator('dim',3);
        i1inp = [0 0 0]';
        i2 = integrator('dim',3);
        i2inp = [0 0 0]';
        i3 = integrator('dim',3);
        i3inp = [0 0 0]';
        i4 = integrator('dim',3);
        i4inp = [0 0 0]';
        
    end
    properties (SetAccess = protected )
        locationlabels = {'x','y','z'};
        velocitylabels = {'u','v','w'};
        accelerationlabels = {'ax','ay','az'};
        orientationlabels = {'psi','theta','phi'};
        angularvelocitylabels = {'p','q','r'};
        angularmomentlabels = {'Mx','My','Mz'};
        velearthlabels = {'vx','vy','vz'};
        accelearthlabels = {'ax','ay','az'};
    end
    
    methods
        % Constructor
        function s = stf_nonlin1( varargin )
            if nargin>=1
                if isa( varargin{1}, 'stf_nonlin1cfg' )
                    % initialize with this config
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                    
                end
            else
                s.cfg = stf_nonlin1cfg;
                s.init;
            end
        end
        function t = gettime( this );
           t = this.time; 
        end
    end
end