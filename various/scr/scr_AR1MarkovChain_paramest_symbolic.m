% This script is for symbolic munipulations of the following AR-1 Markov
% Chain for k=1,...,t and estimation of an unknown parameters theta:
% x_k = a x_km1 + v_k
% with v_k ~ N(.;0,sig_v), x1 ~ N(.;0,sig_x1)
% zi_k = x_k + ni_k
% zj_k = x_k + theta + nj_k
% with ni_k ~ N(.;0,sig_ni) and nj_k ~ N(.;0,sig_nj)
% and theta is an unknown variable which has a priori distribution N(.;mu_theta,sig_theta)
% For now; mu_theta = 0 is assumed


syms sig_ni sig_nj
syms sig_x1 sig_v a 
syms theta sig_theta

syms xbar x zi zj

t = 5; % This is the number of steps

for k=1:t
    eval(['syms ','x',num2str(k)]);
    eval(['syms ','zi',num2str(k)]);
    eval(['syms ','zj',num2str(k)]);
end

% stack the variables into vectors
x = [x1];
zi = [zi1];
zj = [zj1];
for k=2:t
    eval( ['x = [x; x',num2str(k),'];'] ); 
    eval( ['zi = [zi; zi',num2str(k),'];'] ); 
    eval( ['zj = [zj; zj',num2str(k),'];'] ); 
end

xbar = [theta;x];

xall = [xbar;zi;zj];

Hi = eye(t);
Hibar = [zeros(t,1), Hi ];
Hj = eye(t);
Hjbar = [ones(t,1), Hj ];


% Now, construct C_x in accordance with the AR1 Markov chain 
% x_1 ~ N(.;0,sig_x1 )
% x_k = a x_km1 + v_k for k=2,...,t
% with v_k ~ N(.;0,sig_v)
A = fliplr( hankel([ zeros(1,t-2) 1 -a] ) );
A = A(1:end-1,:);

C_x_inv =  transpose(A)*( eye(t-1)*(1/sig_v^2) )*A ;
C_x_inv(1) = C_x_inv(1) + 1/sig_x1^2 ;

C_all_inv = blkdiag( 1/sig_theta, C_x_inv, eye(t)*(1/sig_ni^2), eye(t)*(1/sig_nj^2) );

T = blkdiag( 1, eye(t), eye(t), eye(t) );
T(t+1+1:t+1+t,1:t+1) = -Hibar;
T(t+1+t+1:t+1+t+t,1:t+1) = -Hjbar;

C_joint_inv = transpose(T)*C_all_inv*T;
dim = length( xall );

K_xbarzizj = ( 1/( (2*pi)^(dim/2)* sqrt(det( inv(C_joint_inv)) )   ));
p_xbarzizj = K_xbarzizj*exp( -0.5*transpose( xall )*( C_joint_inv  )*xall );

%p_all_marg = p_xbarzizj;
%for ind = 1:length(xall)
%   p_all_marg =  int( p_all_marg ,xall( ind ));
%end

