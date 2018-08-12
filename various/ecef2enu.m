% ECEF2ENU - convert earth-centered, earth-fixed (ECEF) cartesian
%            coordinates to local vertical coordinates East North
%            Up (ENU) with the coordinate centre defined in geodetic
%            coordinates latitude, longitude, altitude
% USAGE:
% [x,y,z] = lla2ecef(x_ecef, y_ecef, z_ecef, lat, long, alt);
% 
% x = ENU X-coordinate (m)
% y = ENU Y-coordinate (m)
% z = ENU Z-coordinate (m)
% lat = geodetic latitude (radians)
% lon = longitude (radians)
% alt = height above WGS84 ellipsoid (m)
% 
% Notes: This function assumes the WGS84 model.
%        Latitude is customary geodetic (not geocentric).
% 
% Source: "Department of Defense World Geodetic System 1984"
%         Page 4-4
%         National Imagery and Mapping Agency
%         Last updated June, 2004
%         NIMA TR8350.2
% 
% Michael Kleder, July 2005

function [x_enu,y_enu,z_enu]=ecef2enu(x,y,z,lat,lon,alt)

% WGS84 ellipsoid constants:
a = 6378137;
e = 8.1819190842622e-2;

% intermediate calculation
% (prime vertical radius of curvature)
N = a ./ sqrt(1 - e^2 .* sin(lat).^2);

% Find the centre in ECEF
% results:
x_c = (N+alt) .* cos(lat) .* cos(lon);
y_c = (N+alt) .* cos(lat) .* sin(lon);
z_c = ((1-e^2) .* N + alt) .* sin(lat);

% Find the difference vector
x_d = x - x_c;
y_d = y - y_c;
z_d = z - z_c;

% Rotate the difference vector
lambda = lon;
phi = lat;

x_enu = -sin( lambda)*x_d + cos(lambda)*y_d;
y_enu = -sin(phi)*cos(lambda)*x_d + (-sin( phi )*sin( lambda) )*y_d + cos(phi)*z_d;
z_enu = cos( phi )*cos( lambda )*x_d + cos( phi )*sin( lambda )*y_d + sin(phi)*z_d;



return