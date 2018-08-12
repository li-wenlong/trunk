classdef stf_identity < stf_lingauss
    methods
        function s = stf_identity( varargin )
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
        end % stf_indentity end        
    end % methods end
end
        