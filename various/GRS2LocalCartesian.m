function [X,Y,Z] = GRS2LocalCartesian(x, y, z, ...
    lat_origin, lon_origin, alt_origin)
% GRS2LOCALCARTESIAN converts from geocentric reference systems to
% a local Cartesian system centred on the specified origin
% Input: x, y, z in metres
%        lat_origin, lon_origin, alt_origin in degrees and metres
% Output: [X,Y,Z] in metres
%
% Written by:  Dr PE Howland, NATO C3 Agency
% Date:        21 April 2005
% Version:     1.0

%WGS84 earth ellipsoid parameters
a=6378137.0;
f=1/298.257223563;
e2=1-(1-f)^2;
deg2rad = pi/180;

sin_lon = sin(deg2rad*lon_origin);
cos_lon = cos(deg2rad*lon_origin);
sin_lat = sin(deg2rad*lat_origin);
cos_lat = cos(deg2rad*lat_origin);

v = a/sqrt(1-e2*sin_lat^2);

A = [-sin_lon          cos_lon         0; ...
     -sin_lat*cos_lon -sin_lat*sin_lon cos_lat; ...
      cos_lat*cos_lon  cos_lat*sin_lon sin_lat];
  
B = [0; e2*v*sin_lat*cos_lat; e2*v*sin_lat^2-(v+alt_origin)];

C = A*[x;y;z];

X = C(1,:)+B(1);
Y = C(2,:)+B(2);
Z = C(3,:)+B(3);

end
