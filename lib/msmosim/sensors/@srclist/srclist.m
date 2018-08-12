classdef srclist
    properties ( SetAccess = protected )
        src
        time
    end
    methods 
        function s = srclist( varargin )
            if nargin == 0
                % Do nothing
            elseif nargin == 1
                error('insufficient number of input arguments!')
            elseif nargin == 2
                s = s.addsources( varargin{1}, varargin{2} );
            else
                error('Wrong number of input arguments!')
            end
        end
    end
end