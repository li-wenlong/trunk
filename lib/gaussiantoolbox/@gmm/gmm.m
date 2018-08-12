% GMM Object
% g = gmm; returns a single component 1-D Gaussian pdf with 0 mean, 
% unity variance and weight 1.

classdef gmm
    properties (SetAccess = private, Hidden = true)
        parClassName = ''              % parent class name (system type)
        props  = {...
            'w';...
            'pdfs'...
            }
        values = { ...
            'numeric array';... % 1
            'gk array'...
            }
    end
    properties
        w
        pdfs
    end
    methods
        function g = gmm(varargin)  
            if nargin== 0
                g.w = 1;
                g.pdfs = cpdf(gk);
            elseif nargin == 1
                if isa(varargin{1}, 'gmm')
                    g = gmm( varargin{1}.w, varargin{1}.pdfs );
                    return;
                else
                    error('Wrong input type!');
                end
            elseif nargin == 2
                w = varargin{1}(:);
                w = w/sum(w);
                pdfs = varargin{2}(:);
                for i=1:length(pdfs)
                    pdfs(i) = cpdf(pdfs(i));
                end
                g.w = w;
                g.pdfs = pdfs;
            elseif nargin == 3
                g = gmm;
                g.w = varargin{3}(:);
                g.w = g.w/sum(g.w);
                g.pdfs = g.pdfs([]);
                for i=1:length(g.w)
                g.pdfs(i) = cpdf( gk( varargin{2}(:,:,i), varargin{1}(:,i) ));
                end
                
                
            end
        end
    end
end
