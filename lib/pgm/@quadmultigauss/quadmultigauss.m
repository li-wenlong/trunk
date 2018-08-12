classdef quadmultigauss< edgepot % Edge potential class
    properties
        T       % Time exis for the posterior/prediction containers below
        postis  % posterior distributions of node i
        predis  % prediction disttributions of node i 
        postjs  % posterior distributions of node j
        predjs  % prediction distributions of node j
        sensori % sensor object encapsulating H_i and R_i of the linear observation model
        sensorj % sensor object encapsilating H_j and R_j of the linear observation model
        sensorbufferi % This is the measurement buffer of sensor ithat will be taken into account
        sensorbufferj % sensor j's measurement buffer
        associ % This is the association decisions at sensor i
        assocj % This is the association decisions at sensor j
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function q = quadmultigauss(varargin)
            if nargin>=1
                if isa( varargin{1}, 'quadmultigausscfg' )
                    % initialize with this config
                    mycfg = varargin{1};
                elseif isempty(  varargin{1} )
                    mycfg = varargin{1};
                else
                    error('Unknown variable input');
                end
            else
                mycfg = quadmultigausscfg;
            end
             q = q@edgepot( mycfg );
        end
    end
end
