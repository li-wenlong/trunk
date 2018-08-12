classdef stf_circmotion < stf_nonlin1
     properties
         centre
         clockwise
    end
   
    methods
        function s = stf_circmotion( varargin )
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
