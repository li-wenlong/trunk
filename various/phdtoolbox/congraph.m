function E = congraph( loc, varargin )
% CONGRAPH finds the connectivity graph E; note that E is undirected and
% (i, j) \in E implies that (j,i) \in E.
% E = congraph( loc ) returns the edge set E where loc is an array holding the locations of nodes
% and node i, and j are connected if the connecting distance is < 1
% E = congraph( loc, d ) returns the edge set E where loc is an array holding the locations of nodes
% and node i, and j are connected if the connecting distance is < d
% 
% See also GGRAPH, DELGRAPH, SNEI

% Murat Uney

if nargin == 0
    error('At least an array of node locations should be entered!');
elseif nargin == 1
    if length(size(loc))~=2
        error('The array of node locations is an Nx2 array');
    end
    if ~isnumeric(loc)
        error('The array of node locations should be of type numeric!');
    end
    d = 1;
elseif nargin == 2
    if length(size(loc))~=2
        error('The array of node locations is an Nx2 array');
    end
    if ~isnumeric(loc)
        error('The array of node locations should be of type numeric!');
    end 
    d = varargin{1}(1);
    if ~isnumeric(d)
        error('The second argument must be of type numeric');
    end
end

[numNodes, dummy ] = size(loc);
E = [];
for i=1:numNodes
    for j=i+1:numNodes
        if norm( loc(i,:)-loc(j,:) )<= d
            E = [E;[i,j];[j,i]];
        end
    end
end

            

    