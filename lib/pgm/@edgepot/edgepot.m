classdef edgepot % Edge potential class
    properties
        cfg
        e           % (i,j) pair of the edge as its identifier
        sourceid    % id of the source node over this (directed) edge
        sinkid      % id of the sink node over this edge
        thetas      % points to evaluate this edge at
        numthetas   % number of these points
        dim         % dimensionality of thetas
        labels      % label of each dimension
        limits      % limits of the variables along each axis
        initgenfun  % function to generate initial values of thetas
        logpsis     % log edge potential evaluated at \theta_i stored in edgepot.thetas
        psis        % the edge potential evaluations \psi( \theta_i )       
        potfun      % This is the function that will be called to sample from the edge potential
        potobj      %  This is the @gk or @particles object that facilitates a Kernel sum 
                    % (as a KDE) to evalute the potential function given (epoints, sigmae) pairs
        updatefun   % This is the function to update the edge potential by evaluating it at a possibly
                    % new set of thetas
        updateparams % This is FIFO container buffer for passing parameters to updatefun in each call
        updatecount = 0;
        tupdate    % This is the array which will contain the time elapsed during update
    end
    properties (setAccess =protected)
        
    end
    properties ( setAccess = private )
    
    end
    
    methods
        function e = edgepot(varargin)
            if nargin>=1
                if isa( varargin{1}, 'edgepotcfg' )
                    % initialize with this config
                    e = e.init( varargin{1});
                elseif isempty(  varargin{1} )
                    e = e([]);             
                else
                    error('Unknown variable input');
                end
            else
                myedgepotcfg =  edgepotcfg;
                e = e.init( myedgepotcfg );
            end       
        end
    end
end
