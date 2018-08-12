classdef pixmeas < sensmeas
    properties
        row = 1;
        col = 1;
    end
    methods
        function r = pixmeas(varargin)
            r = r@sensmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'pixmeas')
                    r.row = varargin{1}.row;
                    r.col = varargin{1}.col;
                end
            end
            if nargin>=2
                if isnumeric( varargin{1}) && isnumeric(varargin{2})
                    r.row = varargin{1};
                    r.col = varargin{2};
                end
            end

        end
       
    end
end
