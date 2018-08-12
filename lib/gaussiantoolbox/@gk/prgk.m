function pg = prgk( g, varargin )


T = 0;
U = 1/3;
redratio = 1/3; % Reduction ratio
if nargin>=2
    if isnumeric(varargin{1})
        if ~isempty(varargin{1} )
            T = varargin{1}(1);
        end
    else
        error('The second argument should be a scalar!');
    end
end
if nargin>=3
    if isnumeric(varargin{2})
        if ~isempty(varargin{2})
            U = varargin{2}(1);
        end
    else
        error('The third argument should be a scalar!');
    end
end
numcomp = length(g);
Jmax = ceil( numcomp*redratio );

if nargin>=4
    if isnumeric(varargin{3})
        if ~isempty( varargin{3})
            Jmax = ceil( min( max(1,varargin{3}), numcomp ) );
        end
    else
        error('The fourth argument should be a scalar!')
    end
end

zs = getzs(g);
if ~isempty( find(zs<0))
    warning('Negative component in the gk array!!!');
end

% sc = sum( zs ); % sc = ws.*ss where ss are the scale factors for components to integrate to 1
% ss = getzs( cpdf( g ) );
% ws = sc./ss;
% gmmeq = gmm(ws, g );
% pg = sum(ws)*gmm2gk( prgmm( gmmeq, T, U, Jmax   ) );

 [gmmeq, sc] = gk2gmm( g );
 pg = sc*gmm2gk( prgmm( gmmeq, T, U, Jmax   ) );
 
 
 