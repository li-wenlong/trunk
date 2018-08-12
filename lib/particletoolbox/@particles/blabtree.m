function varargout = blabtree( p, varargin )
% PBLABTREE returns the birthlabel trees of the particles as indexes. The
% max. depth of the tree depends on the number of unique entries in the
% birthlabel map, i.e., the blabmap field of a particles object.

tr = [0]; % Start with the parent node;
ind{1} = [1:p.getnumpoints];

if ~isempty( p.blabels )
    ubl = unique( p.blmap,'legacy' );
    for j=1:length(ubl) % This provides the depth
        dims4bl{j} = find( p.blmap == ubl(j) ); % These are the fields of clusters
        subclusterlabels{j} = unique( p.blabels( ubl(j), :) );
        %  disp(sprintf('Number of subcluster labels for field %d  is %d',j,length( subclusterlabels{j}  )));
        for k=1:length( subclusterlabels{j}  )
            subclusterind{j}{k} = find( p.blabels( ubl(j), :) ==  subclusterlabels{j}(k) );
        end
    end
end
