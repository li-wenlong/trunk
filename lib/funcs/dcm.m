function R = dcm( ivector, varargin )
% DCM Directional Cosine Matrix given Euler Angles
%
% DCM considers  counterclockwise rotation
% using the right hand rule with the Z, Y, X rotation order corresponding
% to the Euler angles psi, theta, phi respectively.
%
% R = dcm([psi, theta, phi]) or 
% R = dcm( psi, theta, phi ) where the angles are in rad.s
% returns the rotation transformation R such that if e is the
% representation of a point in Earth Coordinate System, then the Body
% Coordinate System representation b = Re;
% 
% See also IDCM

% 21.10.2010 Murat Uney 


if isa( ivector, 'numeric' )
    if length( ivector)==3
        psi = ivector(1);
        theta = ivector(2);
        phi = ivector(3);
    else
        if nargin == 3 && isa( varargin{1}, 'numeric' ) && isa(varargin{2},'numeric') ...
                && length(varargin{1})==1 && length(varargin{2})==1 && length(ivector) == 1
            psi = ivector(1);
            theta = varargin{1}(1);
            phi = varargin{2}(1);
        else
            error('Could not identify the inputs!');
        end
    end
else
    error('Inputs should be of type numeric');
end

R = [ cos(theta)*cos(psi), cos(theta)*sin(psi), -sin(theta);... % First row
    sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi), ... % R_21
    sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi),...% R_22
    sin(phi)*cos(theta);... % R_33
    cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi),... % R_31
    cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi),... % R_32
    cos(phi)*cos(theta)];

% R = [ cos(theta)*cos(phi), cos(theta)*sin(phi), -sin(theta);... % First row
%     sin(psi)*sin(theta)*cos(phi)-cos(psi)*sin(phi), ... % R_21
%     sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi),...% R_22
%     sin(psi)*cos(theta);... % R_33
%     cos(psi)*sin(theta)*cos(phi) + sin(psi)*sin(phi),... % R_31
%     cos(psi)*sin(theta)*sin(phi) - sin(psi)*cos(phi),... % R_32
%     cos(psi)*cos(theta)];
    