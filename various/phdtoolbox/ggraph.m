function E = ggraph(loc)
% GGRAPH constructs the Gabriel Graph, which is a geometric graph of given
% vertex locations
% E = ggraph(loc) returns the gabriel graph given the locations of points
% in the array loc.
%
% Note that a Gabriel Graph is a subgraph of the Delaunay Triangulation!
%
% See also CONGRAPH, DELGRAPH, SNEI

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

E = zeros( 2*2*size(loc,1) ,2 ); % A delunay triangulation has 2n-2-b triangles under certain conditions
% We assume 2n triangles which can be covered by at most 2*2n edges. Since
% the Gabriel Graph is a subgraph of the Deluanay triangulation we stick
% with a size of 4n
numEdgesXfered = 0;
numNodes = size(loc,1);

for i=1:numNodes
    % Find the distances with the other vertices
     distances = sqrt( sum( (repmat( loc(i,:),numNodes-i+1 , 1)-loc(i:end,:)).^2,2) );
     [sDistances, sIndex] = sort(distances);
     % Starting from the nearest except itself, check the nodes
     for j=2:length(sIndex)
         c = (loc(i,:)+loc(sIndex(j)+i-1,:))/2;
         r = norm( loc(i,:)-loc(sIndex(j)+i-1,:))/2;
         distFromCenter = sqrt( sum( (repmat(c, numNodes,1)-loc).^2,2) );
         nodesInsideC = find( distFromCenter < r);
         nodesInsideC = setdiff( nodesInsideC,[i,sIndex(j)+i-1 ] );
         if isempty(nodesInsideC)
           numEdgesXfered = numEdgesXfered+1;
           E(numEdgesXfered,:) = [i,sIndex(j)+i-1];
         end
     end
end
E = E(1:numEdgesXfered,:);
         
     
     