classdef rbmeasext < rbmeas
    properties
        rangext = 0;
        bearingext = 0;
    end
    methods
        function r = rbmeasext(varargin)
            r = r@rbmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'rbmeasext')
                    r.range = varargin{1}.range;
                    r.bearing = varargin{1}.bearing;
                    r.rangext = varargin{1}.rangext;
                    r.bearingext = varargin{1}.bearingext;
                end
            end
            if nargin>=2
                if isnumeric( varargin{1}) && isnumeric(varargin{2}) && ...
                        isnumeric( varargin{3}) && isnumeric(varargin{4})
                    r.bearing = varargin{1};
                    r.range = varargin{2};
                    r.bearingext = varargin{3};
                    r.rangext = varargin{4};
                end
            end

        end
    end
end
