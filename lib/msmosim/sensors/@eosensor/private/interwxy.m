function [p, w]  = interwxy( o, u )
% [p, w]  = interwxy( o, u )
% Find the intersection of the line passing through origin o and along the 
% unit vector u with the xy plane (z=0).
% p is the coordinates of the point on the plane and 
% p = o + wu
% If u is not in the xy plane itself
p = [];
w = NaN;

myeps = 0.1e-8;

u = u/norm(u);

n = [0 0 1]'; % This is the surface normal for the xy plane
p0 = [-1 0 0]'; % This is a known point in the plane


% Find the unit vector along the projection of u on the plane
n_par = u - (u'*n)*n;

if norm( n_par ) < myeps
    % u is parallel to the plane
    return;
end

n_par = n_par/norm(n_par);

% Find the weight needed along the inverse of n to get from point o to the
% plane


% 1) Find the projection of o on the plane
no = ( o -p0 ) - ( o -p0 )'*n*n;
no = no/norm(no);

o_plane = ( o -p0 )'*no*no + p0; 

w = ( ( o_plane - o )'*n )/ ( u'*n );

p = o + w*u;
