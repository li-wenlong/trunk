function [Xh, varargout] = hackstateestimates( pf )

Xh = [];
if isempty(pf)
    return;
end
particles = pf.particles;
clusterIndx = pf.clusterIndx;
ent = round( pf.ent );

clusterNames = sort( unique([clusterIndx]) );
% Check the cluster sizes
clusterSizes = [];
for i=1:length(clusterNames)
    indx = find( clusterIndx == clusterNames(i) );
    clusterSizes = [clusterSizes, length( indx)];
end
% clusterSizes
[sClusterSizes, sindx] = sort( clusterSizes, 'descend' );

nest = 0;
for i=1:min( ent, length(sindx) )
    if clusterNames( sindx(i) ) ~= 0
        nest = nest + 1;
        indx = find( clusterIndx == clusterNames( sindx(i) ) );
        Xh = [Xh, mean( particles(:, indx) , 2   ) ];
        if nargout == 2
            varargout{1}{nest} = indx;
        end
     end
end
% Now introduce the estimate due to missed detections if the estimated
% number of targets
