function  [ extlabels, varargout] = extlabelswblab( p, varargin )



threshold = 0;
exlabels = [];

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'threshold'}
                if argnum + 1 <= nvarargin
                    threshold = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'exclude'}
                if argnum + 1 <= nvarargin
                    exlabels = varargin{argnum+1};
                    argnum = argnum + 1;
                end   
            case {''}
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end


extlabels = p.labels;
indxs = {};
sclmass  = [];

ulabels = unique( p.labels,'legacy' );
nzind = find( ulabels~= 0 ) ;
[nonzerolabels ]= ulabels( nzind );
zerolabels = find( p.labels == 0 );

numcomps = length( nonzerolabels );
for i=1:numcomps
    indx = find( p.labels == nonzerolabels(i) );
    
    % sublabels
    subclusterlabels = setdiff( unique( p.blabels(1,indx),'legacy' ), exlabels);
    for j=1:length( subclusterlabels )
        % Find corresponding blab associated with zero labels
        subclindx = find( p.blabels(1, zerolabels) == subclusterlabels(j) );
        clmass = sum( p.weights( zerolabels(subclindx)  ) );
        if clmass >= threshold
            extlabels(zerolabels(subclindx)) = nonzerolabels(i);
            indxs = [indxs,{ zerolabels(subclindx) } ];
            sclmass = [sclmass, clmass ];
        end
    end
end


if nargout >= 2
    varargout{1} = indxs;
end
if nargout >= 3
    varargout{2} = sclmass;
end


