classdef region
    properties 
        vertices
        c = [0 0]';
        r = [1];
        type = 0; % 0 for circular, 1 for polygon
    end
    properties ( SetAccess = private )
        
     end
    methods
        function r = region( varargin )
            if nargin >=1
                if isempty(varargin{1})
                    r = r([]);
                    return;
                end
                r = r.init(varargin{:});
            else
                r = r.init('circular',[0 0]',1);
            end
        end
    end
end