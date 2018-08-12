function E = delgraph(loc)
% DELGRAPH constructs the Deluanay Triangulation graph, which is a geometric 
% graph of given vertex locations
% E = delgraph(loc) returns the DT graph given the locations of points
% in the array loc.
%
% See also CONGRAPH, GGRAPH, SNEI

% Murat Uney

if nargin ~= 1
    error('Only one argument should be entered!');
end

if length(size(loc))~=2
    error('The array of node locations is an Nx2 array');
end
if ~isnumeric(loc)
    error('The array of node locations should be of type numeric!');
end
    
% A delunay triangulation has 2n-2-b triangles under certain conditions
% We assume 2n triangles which can be covered by at most 2*2n edges.
delTri = delaunay(loc(:,1),loc(:,2) );
E = tri2ue(delTri);

     
     