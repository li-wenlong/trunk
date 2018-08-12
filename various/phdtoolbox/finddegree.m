function D = finddegree(E, V)
% FINDDEGREE returns the degree of the vertices in an undirected graph
% D = finddegree(E,V) returns the degree of vertices V in the undirected
% graph with the edge set E.
%

% Murat Uney

E = sue(E);
D = zeros(size(V));
for i=1:length(V)
    D(i) = length( find(E(:,1)==V(i)))+length( find(E(:,2)==V(i)));
end
    