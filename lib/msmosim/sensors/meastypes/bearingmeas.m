classdef bearingmeas < sensmeas
    properties
       bearing = 0;
    end
    methods
        function r = bearingmeas(varargin)
            r = r@sensmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'bearingmeas')
                    r.bearing = varargin{1}.bearing;
                end
            end
            if nargin>=2
                if isnumeric( varargin{1}) 
                    r.bearing = varargin{1};
                end
            end

        end
    end
end
