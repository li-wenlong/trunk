function [x,y,z] = Geodetic2LocalCartesian(lat,lon,alt,lat_origin,lon_origin,alt_origin)
% GEODETIC2LOCALCARTESIAN converts from geodetic system to local Cartesian 
% Input:  lat,lon,alt in degrees and metres
%         lat_origin, lon_origin, alt_origin in degrees and metres
% Output: [x, y, z] in metres
%
% Written by:  Dr PE Howland, NATO C3 Agency
% Date:        21 April 2005
% Version:     1.0

[a,b,c] = Geodetic2GRS(lat,lon,alt);
[x,y,z] = GRS2LocalCartesian(a,b,c,lat_origin,lon_origin,alt_origin);

end