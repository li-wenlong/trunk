function deltaij = findiffs(thetai, thetaj, varargin )
% function deltaij = findiffs(thetai, thetaj ) finds the difference vectors
% of the elements in the Cartesian product of thetai and thetaj, i.e.,
% deltaij(:,k) = thetai(:,ki)-thetaj(:,kj) with (ki,kj) \in KixKj
% where Ki={1,..., length(thetai)} and Kj = {1,...,length(thetaj)}
% deltaij = findiffs(thetai, thetaj ) returns a difference vector array of
% size max(thetai, thetaj) after prunning with kmeans clustering
% deltaij = findiffs(thetai, thetaj, 0 ) returns the full Cartesian product
% 

ni = length(thetai);
nj = length(thetaj);

pruneMode = 1;
prune2k = max( ni, nj );
if nargin>=3
    token = varargin{1}(1);
    if token == 0
         pruneMode = 0;
    else
         prune2k = token;
    end
end

% First, find the cartesian product of indices
[c1, c2] = meshgrid([1:ni],[1:nj]);

% The pairs ( c1(j), c2(j) ) correspond to the following differences
 deltaij = - thetai(:,c1(:)) + thetaj(:,c2(:));
 deltaij = ( unique( deltaij', 'rows' ,'legacy') )';
 
 if ~pruneMode
     return;
 end
% If not, we need to prune the number of elements in the product
 % For this, use kmeans clustering
 [idx,C] = kmeans(deltaij', prune2k);
 deltaij = deltaij(:, idx);
 return;
 