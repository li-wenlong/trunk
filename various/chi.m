function [ch, varargout] = chi(G,i)
% ch = chi( E, i )
% returns the child nodes of the node labelled i with respect to the Edge
% array E (2xN). 
% [ch, e ] = chi( E, i)
% returns the list of the Edges from i to the children in e.
% [ch, e ] = chi( G, i) is also a valid function call where G is a cell
% array representing the graph G = {V,E} with E being the list of vertices.
%
% Updated 17.05.2017 unique now is called with 'stable' to have the same
% behaviour
% Updated 20.01.2014 Murat Uney
% First version 2009 Murat Uney

if iscell( G )
    enums = find(G{2}(:,1)== i);
    ch = unique( G{2}( enums,2),'stable');
else
    enums = find(G(:,1)== i);
    ch = unique( G( enums,2), 'stable');
end

if nargout>1
    varargout{1} = enums;
end
    


