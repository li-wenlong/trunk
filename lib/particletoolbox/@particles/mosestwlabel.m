function  [Xh, varargout] = mosestwlabel( p, varargin )


Xh = [];
Cs = [];
indxs = [];
sClusterWeights = [];
clindx = [];
if isempty(p)
    return;
end

threshold = 0.5;

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
            case {''}
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end


ulabels = unique( p.labels,'legacy' );
nzind = find( ulabels~= 0 ) ;
[nonzerolabels ]= ulabels( nzind );

zerolabels = find( p.labels == 0 );

if ~isempty( nonzerolabels )
    


% Check the cluster sizes and weights
numcomps = length( nonzerolabels );
clusterWeights = [];
clusterSizes = [];
for i=1:numcomps
    indx = find( p.labels == nonzerolabels(i) );
    clusterSizes = [clusterSizes, length( indx)];
    clusterWeights = [ clusterWeights, sum( p.weights(indx) )];
end

[sClusterWeights, sindx] = sort( clusterWeights, 'descend' );
[xdim Np] = size(p.states);

clindx = find( sClusterWeights >= threshold );

Cs = {};
indxs = {};
nest = length(clindx);
for i=1:nest
    indx = find( p.labels == nonzerolabels( sindx(i) ) );
    % Check the second moment of the cluster
    indxs{i} = indx;
    C = wcov( p.states(:, indx), p.weights(indx) );
    Cs{i} = C;    
    Xh = [Xh, mean( p.states(:, indx) , 2 ) ];
end
end
    
if nargout >= 2
    varargout{1} = Cs;
end

if nargout >= 3
    varargout{2} = indxs;    
end
if nargout >= 4
    varargout{3} = sClusterWeights(clindx);
end


