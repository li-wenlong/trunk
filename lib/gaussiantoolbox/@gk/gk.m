% GK Object
% g = gk; returns a 1-D Gaussian Kernel with 0 mean, unity variance and
% scale factor 1.
% g = gk(C,m) returns a 1-D Gaussian Kernel with covariance matrix C and
% mean m.
classdef gk
    properties  (SetAccess = private, Hidden = true)
        parClassName = '';                        % parent class name (system type)
        props  = {...
            'm';...
            'C';...
            'S';...
            'Z';...
            'isScalar';...
            'sval'...
            };
        values = { ...
            'numeric array';... % 1
            'numeric 2-D array';...
            'numeric 2-D array';...
            'scalar';...
            'logical';...
            'scalar'...
            };
        
    end
    properties
        m
        C
        S
        Z 
        isScalar 
        sval 
    end
    methods
        function g = gk(varargin)
            if nargin== 0
                g.m = 0;
                g.C = 1;
                g.S = 1;
                g.Z = 1;
                g.isScalar = 0;
                g.sval = 0;
            elseif nargin >= 1
                if isempty( varargin{1} )
                    g = g([]);
                else
                    
                    C = varargin{1};
                    if ~isnumeric(C)|| ndims(C)~=2
                        error('The first argument should be a 2-D numerical array');
                    end
                    if ~isempty( find( isnan(C)==1)) || ~isempty( find( isinf(C)==1))
                        error('nan of inf in the covariance matrix');
                    end
                    R = chol(C)';
                    Rinv = R^(-1);
                    %     % Construct the inverse covariance
                    S = Rinv'*Rinv;
                    % S = inv(C);
                    Z = 1;
                    m = zeros(size(C,1),1);
                    if nargin >=2
                        m = varargin{2}(:);
                        if ~isnumeric(m) || size(C,1)~=length(m)
                            error('The second argument should be a 1-D numerical array of compatible length with the first argument!');
                        end
                    end
                    if nargin>=3
                        Z = varargin{3}(1);
                        if ~isnumeric(Z)
                            error('The third argument should be a scalar');
                        end
                    end
                    g.m = m;
                    g.C = C;
                    g.S = S;
                    g.Z = Z;
                    g.isScalar = 0;
                    g.sval = 0;
                end
                
            end
         
        end
    end
end