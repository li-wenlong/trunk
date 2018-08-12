% Rectiliner cam model
% the up-right-VPN(view-plane normal) are x-y-z
classdef eosensor < sensor
    properties
        pdprofile;  % Probability of detection
        minrange; % The four parameters specifying the frustum
        maxrange;
        horfov; % Horizontal field of view
        verfov; % Vertical field of view
        stdanghor; % standard deviation in the horizontal direction
        stdangver; % standard deviation in the vertical direction
        F; % effective focal length
        S2; % Distance of the image plane from the lens
        ipwidth; % image plane width
        ipheight; % image plane height
        numrows; % Resolution in the horizontal direction
        numcols; % Resolution in the vertical direction
        pixwidth;
        pixheight;
    end
    methods
        function s = eosensor(varargin)
            s = s@sensor( eosensorcfg );
            if nargin>=1
                if isa( varargin{1}, 'eosensorcfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = eosensorcfg;
                s.cfg.cluttercfg = eobinomclutcfg;
                s.cfg.pdprofilecfg = pdprofilelindeccfg;
                s.init;
            end
        end 
    end
end
