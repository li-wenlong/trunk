classdef pf1 % sampling importance resampling with optional regularisation
    properties
        cfg
        Z
        targetmodel
        lgen = labelgen;
        veldist
        regvar
        regflag
        maxnumpart
        numpart
        pred
        post
        parlhood
        predintbuffer
        postintbuffer
        infobuffer
    end
       
    methods
        function p = pf1(varargin)
            if nargin>=1
                if isa( varargin{1}, 'pf1cfg' )
                    % initialize with this config

                    p.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                p.cfg = pf1cfg;
                p.init;
            end
        end
    end
end
        
