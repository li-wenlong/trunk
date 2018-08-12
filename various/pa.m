function [p, varargout] = pa( G, i )
% p = pa( E, i )
% returns the parent nodes of the node labelled i with respect to the Edge
% array E (2xN). 
% [p, e ] = pa( E, i)
% returns the list of the edges towards i from the parents in e.
% [p, e ] = pa( G, i) is also a valid function call where G is a cell
% array representing the graph G = {V,E} with E being the list of vertices.
%
% Updated 20.01.2014 Murat Uney
% First version 2009 Murat Uney
if iscell( G )
    enums = find( G{2}(:,2)== i);
    p = unique( G{2}( enums, 1),'stable');
else
   enums =  find( G(:,2)== i);
   p = unique( G( enums, 1),'stable');
end

if nargout>1
    varargout{1} = enums;
end
    
