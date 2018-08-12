function [F,Q,sQ] = lingauss2( dT, rho )
% function [F,Q,sQ] = lingauss2( dT, rho )
% returns the linear dynamical system representation matrices for a 
% noisy acceleration model where
% x_k+1 = F x_k + sQ n
% leading to x_k+1 ~ N( .; F x_k, Q )
% with x = [ x y vx vy ]^T
%     | 1  0  dT 0  |
%     | 0  1  0  dT | 
% F = | 0  0  1  0  |
%     | 0  0  0  1  |
%    
%          | 1/4dT^3    0     1/2dT^2    0    |
%          | 0       1/4dT^3     0    1/2dT^2 | 
% Q = rho^2|  1/2dT^2    0       dT     0     |
%          |  0     1/2dT^2      0      dT    |
%    


Q = rho^2*[...
        dT^3/3 0 dT^2/2 0;...
        0 dT^3/3 0 dT^2/2;... 
        dT^2/2 0 dT 0;...
         0 dT^2/2 0 dT];
F = [ 1 0 dT 0;...
      0 1 0 dT;...
      0 0 1 0 ;...
      0 0 0 1];
 
 sQ = sqrtm( Q );
     
    
     