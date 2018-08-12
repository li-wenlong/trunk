classdef kf % sampling importance resampling with optional regularisation
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        pred
        post
        initstate
        veldist
        parlhood
        parloglhood
        condpz
        predbuffer
        postbuffer
        infobuffer
    end
       
    methods
        function p = kf(varargin)
            if nargin>=1
                if isa( varargin{1}, 'kfcfg' )
                    % initialize with this config

                    p.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                p.cfg = kfcfg;
                p.init;
            end
            
        end
    end
end
        
