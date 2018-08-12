classdef rssmeas < sensmeas
    properties
        P = 0;
    end
    methods
        function r = rssmeas(varargin)
            r = r@sensmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'rssmeas')
                    r.P = varargin{1}.P;
                end
            end
            if nargin>=1
                if isnumeric( varargin{1})
                    r.P = varargin{1};
                end
            end

        end
    end
end
