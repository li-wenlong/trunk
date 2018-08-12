classdef extsensorcfg < sensorcfg
    properties
        pd = 0.95;
        maxrange = 10000;
        alpha = 90*pi/180;
        stdang = pi/180;
        stdrange = 50;
 %   The following variables/parameters may need to be pre-defined:
    %       [m,P] - the mean & covariance matrix for the Gaussian from
    %               which the particles are sampled.
    %
    %       False alarm (Poisson) process parameters (only required if
    %       filtering in clutter):
    %       [x_min,x_max] - observation region x-axis dimensions.
    %       [y_min,y_max] - observation region y-axis dimensions.
    %              lambda - clutter rate.
    %
    %       Ellipse parameters:
    %            gamma - desired number of points on the half-ellipse.
    %            angle - angle of rotation in degrees.
    %       major_axis - length of major axis.
    %       minor_axis - length of minor axis.
    %
    %       r_sig1 - standard deviation (squared) of the Gaussian
    %                measurement noise in relation to the points on the
    %                half-ellipse

        m = [0 0 0 0]';  
        P = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
        x_min = -8000;
        x_max = 8000;
        y_min = -8000;
        y_max = 8000;
        lambda = 1;
        gamma = 16;
        angle = 0;
        major_axis =  600;
        minor_axis = 400;
        r_sig1 = 1;
        
    end
    methods
        function r = extsensorcfg
            ccfgobj = poisclut2cfg;
            ccfgobj.lambda = 1;
            ccfgobj.alpha = 90*pi/180;
            ccfgobj.range = 8000;
            r.cluttercfg = ccfgobj;

            r.lambda = ccfgobj.lambda;
            r.alpha = ccfgobj.alpha;
            r.x_min = -ccfgobj.range;
            r.x_max = ccfgobj.range;
            r.y_min = 0;
            r.y_max = ccfgobj.range;
        end
    end
end
