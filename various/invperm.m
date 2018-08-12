function i = invperm( r )
% function i = invperm( r )
% returns the inverse permutation i given a permutation r.
% E.g., if r = [3,8,5,10,9,4,6,1,7,2]
% then i = [8,10,1,6,3,7,9,2,5,4]
%
% See also, REORDERMAT 

% Murat Uney 17.06.2017
Einv = reordermat( r )';
i = Einv*[1:size(Einv,2)]';
i = reshape( i, size( r ));