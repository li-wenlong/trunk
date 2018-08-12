function ind = findedge( E, e )
% i = findedge( E, e ) finds the (row) index of the edge e in the form (i,j)
% in the set of edges E.

ind = [];
% Find all the edges that has e(1) as the source node
[chi_, eind ] = chi( E,e(1) );

% Find e(2) among the children and return the associated edge index
i1 = find( chi_ == e(2) );

if ~isempty( i1 )
    ind = eind( i1 );
end