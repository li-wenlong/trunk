classdef rbrrmeas < sensmeas
    properties
        range = 0;
        bearing = 0;
        rangerate = 0;
    end
    methods
        function r = rbrrmeas(varargin)
            r = r@sensmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'rbrrmeas')
                    r.range = varargin{1}.range;
                    r.bearing = varargin{1}.bearing;
                    r.rangerate = varargin{1}.rangerate;
                end
            end
            if nargin>=3
                if isnumeric( varargin{1}) && isnumeric(varargin{2}) && isnumeric(varargin{3})
                    r.bearing = varargin{1};
                    r.range = varargin{2};
                    r.rangerate = varargin{3};
                end
            end

        end
    end
end
