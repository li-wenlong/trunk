function r = mat2perm( E )
% function t = mat2perm( E )
% returns the permutation encoded in the matrix E 
% as y=Ex sastisfies y = [x(r(1)),x(r(2)),...,x(r(end))]
%
% See also, INVPERM, REORDERMAT

% Murat Uney 16.06.2017
% Find r
r = E*[1:size(E,2)]';

% Remove zero entries
r( find(r==0) ) = [];