function [X,Y,Z] = Geodetic2GRS(Lat, Lon, Alt)
% GEODETICTOGRS converts from geodetic to geocentric reference system
% Input: Lat, Lon, Alt in degrees and metres
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

Lat = deg2rad*Lat;
Lon = deg2rad*Lon;

cos_lat = cos(Lat);
sin_lat = sin(Lat);

k = a./sqrt(1-e2.*sin_lat.^2);

X = (k+Alt).*cos_lat.*cos(Lon);
Y = (k+Alt).*cos_lat.*sin(Lon);
Z = (k.*(1-e2) + Alt).*sin_lat;
