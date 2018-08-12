function pg = prgmm( g, varargin )
% PRGMM: Prune Gaussian Mixture Model
% pg = prgmm(g) prunes the GMM g and returns in pg with the default
% pg = prgmm(g[, T, U, Jmax] )

T = 10e-8;
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
numcomp = length(g.w);
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

l = 0;
I = find( g.w >= T);
if isempty( I )
    pw = [];
    pgks = g.pdfs;
else
    while( ~isempty(I) )
        l = l+1;
        [maxval, j] = max(g.w(I));
        
        Idiffj = [[1:j-1],[j+1:length(I)]];
        dists = mahdist( g.pdfs(I(j)), g.pdfs( I ) );
        L = I( find( dists <= U ) );
        if ~isempty(L)
            pw(l) = sum(g.w(L));
            mL = getmeans(g.pdfs(L));
            nm = sum( mL.*repmat( g.w(L)', size(mL,1),1 ),2 )/pw(l);
            % Update the Covariance
            evL = nm -  mL(:,1);
            nC = get(g.pdfs(L(1)),'C')*g.w(L(1))/pw(l) + evL*evL';
            for i=2:length(L)
                evL = nm -  mL(:,i);
                nC = nC + get(g.pdfs(L(i)),'C')*g.w(L(i))/pw(l) + evL*evL';
            end
            %%%
            if ~isempty( find( isnan(nC)==1))
                aa=1;
            end
            pgks(l) = cpdf( gk( nC, nm  ) );
        else
            pw(l) = g.w( I(j));
            pgks(l) = g.pdfs( I(j) );
        end
        
        I = setdiff(I, L);
    end
end
% The pw is already in acsending order dur to the argmax line
numcomps = min( length(pw), Jmax );

pg = gmm( pw(1:numcomps), pgks(1:numcomps)  );