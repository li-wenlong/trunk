function E = tri2ue( tri )
% TRI2UE converts the output of DELAUNAY to a set of undirected edges
% E = tri2ui(tri) returns the set of Edges E as an Nx2 array in which each
% edge represents an undirected connection; hence either (i,j) or (j,i)
% appear. tri is the Mx3 output of the DELAUNAY bearing the indices of the
% vertices of the triangles.
% 
% See also DELAUNAY, CONGRAPH, GGRAPH

% Murat Uney

allE = [ tri(:,1), tri(:,2); tri(:,3),tri(:,1)];
% Now discard multiple occuring (i,j) s and all (j,i)s
E = sue(allE);


       
    
