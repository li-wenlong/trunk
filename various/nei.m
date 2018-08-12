function ne = nei( G, i)
% ne = nei( E, i )
% returns the neighbours nodes of the node labelled i with respect to the Edge
% array E (2xN) of an undirected graph. 
% The representation assumes that (i,j) \in E if and only if (j,i) \in E. 
% [ne, e ] = nei( E, i)
% returns the list of the edges i from and to i from the neighburs in e.
% [ne, e ] = nei( G, i) is also a valid function call where G is a cell
% array representing the graph G = {V,E} with E being the list of vertices.
%
% Updated 20.01.2014 Murat Uney
% First version 2009 Murat Uney
[ch, e1] = chi( G, i);
[pa_, e2] = pa(G,i);

ne = intersect(ch, pa_ );

if nargout>1
    varargout{1} = [e1;e2];
end
    