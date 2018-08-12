classdef eosensorcfg < sensorcfg
    properties
        pdprofilecfg ;
        F = 0.004; % effective focal length of the lens (select between, e.g., 4-12mm )
        S2 = 0.0127; % Distance of the image plane from the lens (select as, e.g., 12.7 mm (half inch) )
        ipwidth = 0.006*6; % image plane width
        ipheight = 0.006; % image plane height
        minrange = 100; % The four parameters specifying the frustum
        maxrange = 4000;
        % horfov ; % Horizontal field of view
        % verfov ; % Vertical field of view
        stdanghor = 0; % standard deviation in the horizontal direction
        stdangver = 0; % standard deviation in the vertical direction
        numrows = 768; % Resolution in the vertical direction
        numcols = 492*6; % Resolution in the horizontal direction
    end
    methods
        function e = eosensorcfg
            e.cluttercfg = eobinomclutcfg;
            e.cluttercfg.p = 0.01;
            e.cluttercfg.n = e.numrows*e.numcols;
            
            pinhole_height = 10;
            pinhole_ray2earthsurface = 3000;
            
            e.location = [0 0 pinhole_height]';
            
            ph_theta = atan2( pinhole_height, pinhole_ray2earthsurface); 
            
            e.orientation = [0 ph_theta 0]';
            
            % e.verfov = 2*( atan2( pinhole_height, pinhole_ray2earthsurface ) );
            e.pdprofilecfg = pdprofilelindeccfg;
        end
    end
end
