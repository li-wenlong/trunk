function e = pangle( e )
% PANGLE returns the principle value of an array of angles in rad.s.
% p = pangle(e); returns the principle value of e in p.
%

% Murat Uney 04.11.2010


e = reshape( mod( e(:) + pi, 2*pi ) - pi, size(e) );