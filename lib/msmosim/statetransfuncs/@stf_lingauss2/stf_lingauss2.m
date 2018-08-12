classdef stf_lingauss2 < stf_nonlin1
     properties
        F
        Q
        srQ
        dT
        psd
     end
   
    methods
        function s = stf_lingauss2( varargin )
            if nargin>=1
                if isa( varargin{1}, 'stf_nonlin1cfg' )
                    % initialize with this config
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.init;
            end
        end
        
    end
end
