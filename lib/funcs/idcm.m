function [ ea, varargout ] = idcm(R)
% IDCM produces the Euler Angles given a Directional Cosine Matrix
%
% IDCM considers counterclockwise rotation
% using the right hand rule with the Z, Y, X rotation order corresponding
% to the Euler angles psi, theta, phi respectively.
%
% [psi, theta, phi] = idcm(R) or 
% ea = idcm( R ) returns the Euler angles are in rad.s
% such that 
% R = dcm( ea ) or R = dcm(psi, theta, phi)
% 
% See also DCM

% 21.10.2010 Murat Uney 

if isa( R, 'numeric' )
    dims = size(R);
    if length(dims)==2
        if ~(dims(1)==3 && dims(2)==3)
           error('Input must be a square matrix; specifically a DCM matrix of 3x3!');
        end
    else
        error('Input must be a DCM matrix of 3x3!');
    end
else
    error('Input must be of type numeric; specifically a DCM matrix of 3x3!');
end

theta = asin( -R(1,3) );

if abs( -R(1,3) - 1 ) > eps || abs( -R(1,3) - (-1) ) > eps
    psi = atan2( R(1,2), R(1,1) );
    phi = atan2( R(2,3), R(3,3) );

else
    theta = pi/2;
    phi = atan2( R(3,1), -R(2,1) );
    psi = 0;
end

% [psi, theta, phi] = threeaxisrot( R(1,2), R(1,1), -R(1,3), ...
%                                    R(2,3), R(3,3), ...
%                                   -R(2,1), R(2,2));

if nargout == 3
    ea = psi;
    varargout{1} = theta;
    varargout{2} = phi;
else
    ea = [psi, theta, phi]';
end


end  
% function [r1 r2 r3] = threeaxisrot(r11, r12, r21, r31, r32, r11a, r12a)
% % find angles for rotations about X, Y, and Z axes
% r1 = atan2( r11, r12 );
% r2 = asin( r21 );
% r3 = atan2( r31, r32 );
% 
%     for i = find(abs( r21 ) >= 1.0)
%         r1(i) = atan2( r11a(i), r12a(i) );
%         r2(i) = asin( r21(i) );
%         r3(i) = 0;
%     end
% end

