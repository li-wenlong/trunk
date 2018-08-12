function o = mapang( ang )
% This function maps an array of angles in radians onto the interval [-pi,pi]
o = mod( ang, 2*pi );

ind = find( o>= pi );
o(ind) = o(ind) - 2*pi;