function E = reordermat( r )
% function E = reordermar( r )
% returns a reordering matrix given the mapping encoded in r
% y=Ex is then y = [x(r(1)),x(r(2)),...,x(r(end))]
%
% See also MAT2PERM, INVPERM

% Murat Uney 16.06.2017

%
% This is the dimensionality of x
dx = max(r);

% These are the entries in E that will be non zero
e = sort(r);

% This is the dimensionality of y
dy = length(r);

E = zeros(dy,dx);
E( 1:dy , r ) = eye(dy);
% 
% % This is the reordering submatrix
% E_ = eye(dy);
% E_ = E_( r - min(r)+ 1,:);
% E(:,e) = E_;