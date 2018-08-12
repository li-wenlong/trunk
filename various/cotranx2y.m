function y = cotranx2y( x, tx, ty)
% function y = cotranx2y( x, tx, ty)
% applies a coordinate transformation to the Gaussian kernel with mean
% state vector x=[x_1,x_2, v_1, v_2] and covariance Px
% The coordinate transform is described by the body parameters of x an y
% given in tx and ty.
% tx = [ s1, s2, psi ] is the heading and centre of the coordinate frame in
% which x represents a point.
% ty captures the same parameters for the desired coordinate frame in which
% x will be represented in.

% Set x as the remote
if length(tx)==3
    alpha_j = tx(3);
else
    alpha_j = 0;
end

s_j = tx([1,2]);

% Set y as the local
if length( ty ) == 3
    alpha_i = ty(3);
else
    alpha_i = 0;
end
s_i = ty([1,2]);

R_RE = dcm( alpha_j*pi/180, 0, 0 ); % Earth to remote
R_LE = dcm( alpha_i*pi/180, 0, 0 ); % Earth to local

% Exclude the z directyon
R_RE = R_RE([1:2],[1:2]);
R_LE = R_LE([1:2],[1:2]);

R_LR = R_LE*(R_RE'); % Remote to local
R_RL = R_LR'; % local to remote, equal to R_RE*(R_LE')

% Find the rotation for the covariance matrix
T = [R_LR, zeros(2);zeros(2), R_LR];

y = x; % Now we will transform remote to local
for i=1:length( x )
    y(i).m([1,2]) = R_LR*y(i).m([1,2]) + R_LE*( s_j - s_i  );
    y(i).m([3,4]) = R_LR*y(i).m([3,4]);
    
    % Rotate the covariance matrix
    y(i).C = T*y(i).C*(T');
end
