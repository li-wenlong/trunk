function [Xh, varargout] = mosestodc( these )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
if isempty(these)
    return;
end
particles = these.catstates;
weights = these.catweights;
clusterIndx = these.getlastlabel;

clusterNames = sort( unique([clusterIndx],'legacy') );
% Check the cluster sizes
clusterSizes = [];
clusterWeights = [];
Xhs = {};
for i=1:length(clusterNames)
    indx = find( clusterIndx == clusterNames(i) );
    clusterSizes = [clusterSizes, length( indx)];
    clusterWeights = [ clusterWeights, sum( weights(indx) )];
    
end
% clusterSizes
%[sClusterSizes, sindx] = sort( clusterSizes, 'descend' );
[sClusterWeights, sindx] = sort( clusterWeights, 'descend' );
[xdim Np] = size(particles);
ent = round(sum(weights));

nest = 0;
for i=1:min( ent, length(sindx) )
    if clusterNames( sindx(i) ) ~= 0
        nest = nest + 1;
        indx = find( clusterIndx == clusterNames( sindx(i) ) );
        % Check the second moment of the cluster
        C = cov( particles(:, indx)' );
        if rank(C)< xdim
            continue;
        end
        
        Xh = [Xh, mean( particles(:, indx) , 2   ) ];
        if nargout == 2
            varargout{1}{nest} = C;
        end
        
        if nargout == 3
            varargout{2}{nest} = indx;
        end
    end
end
