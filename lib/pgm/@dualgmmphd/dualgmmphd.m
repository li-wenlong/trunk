classdef dualgmmphd< edgepot % Edge potential class
    properties
        T       % Time exis for the posterior/prediction containers below
        predis  % prediction disttributions of node i 
        predjs  % prediction distributions of node j
        filteri % GMM PHD filter object for node i 
        filterj % GMM PHD filter object for node j
        sensori % sensor object encapsulating H_i and R_i of the linear observation model
        sensorj % sensor object encapsilating H_j and R_j of the linear observation model
        sensorbufferi % This is the measurement buffer of sensor ithat will be taken into account
        sensorbufferj % sensor j's measurement buffer
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function q = dualgmmphd(varargin)
            if nargin>=1
                if isa( varargin{1}, 'dualgmmphdcfg' )
                    % initialize with this config
                    mycfg = varargin{1};
                elseif isempty(  varargin{1} )
                    mycfg = [];
                else
                    error('Unknown variable input');
                end
            else
                mycfg = dualgmmphdcfg;           
            end
            q = q@edgepot( mycfg );
        end
    end
end
