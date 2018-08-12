classdef mlinmeas
    properties
        Z;
    end
    methods
        function m = mlinmeas(varargin)
            if nargin>=1
                if isa(varargin{1},'mlinmeas')
                    m.Z = varargin{1}.Z;
                elseif isnumeric( varargin{1})
                    m.Z = varargin{1};
                end
            end
        end
    end
end
