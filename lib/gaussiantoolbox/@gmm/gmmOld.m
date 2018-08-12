function g = gmm(varargin)
% GMM Object
% g = gmm; returns a single component 1-D Gaussian pdf with 0 mean, 
% unity variance and weight 1.
% 

g.parClassName = '';                        % parent class name (system type)

g.props  = {...
    'w';...
    'pdfs'...
 };


g.values = { ...
    'numeric array';... % 1
    'gk array'...
};

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
end

g = class(g,'gmm');
