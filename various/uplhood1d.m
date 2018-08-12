function [C, a, B] = uplhood1d( Cu, au, Bu, Cl, al, Bl )
% This function performs the following multiplication for updating the
% parameter likelihood in a 1-D Gaussian state space model :
% l(z^i_{1:k},z^j_{1:k}| \theta) 
% = p( z^i_k, z^j_k | \theta, z^i_{1:k-1},z^j_{1:k-1} ) l(z^i_{1:k-1},z^j_{1:k-1}| \theta)


dc = size( Cu, 1); % dim of the current measurements
dh = size( Cl, 2); % dim of the measurement histories in the conditioned part

T0 = [ eye(dc), -Bu(:,1), -Bu(:,2:end) ];
m0 = [ zeros(dc,1); au];

T1 = [ -Bl, eye(dh) ];
m1 = [ al; zeros(dh,1) ];

m0t = [ T0'*inv( T0*T0' )*au];

Lambda_u = inv( Cu );
Lambda_l = inv( Cl );

Lambda0 = transpose( T0 )*Lambda_u*T0;

m1t = [ T1'*inv( T1*T1' )*al ];
Lambda1 = transpose( T1 )*Lambda_l*T1;

Lambda01 = Lambda0(dc+1:end,dc+1:end);
m01 = m0t(dc+1:end);

[C_f,m_f] = gaussmultinf( Lambda01,m01, Lambda1, m1t);

Lambda_f = inv( C_f );

Lambda_all = [ Lambda0(1:dc,1:dc), Lambda0(1:dc,dc+1:end) ; Lambda0(dc+1:end,1:dc), Lambda_f ];
m_all = [ m0(1:dc); m_f];

[C, mu_f, a, B ] = gausscond( inv(Lambda_all), [dc+1]  , m_all);



function [Lambda_f,m_f] = gaussmultinf(Lambda_0,m_0, Lambda_1, m_1)


% Now, the information matrix of the EMD
Lambda_f = Lambda_0 + Lambda_1;

% Now, invert it to find the covariance matrix of the EMD
R = chol(Lambda_f);
Rinv = R^(-1);

C_f = Rinv*Rinv';
% Done!

% Second, find the linear transform parameterising the mean vector
m_f = C_f*( Lambda_0*m_0 + Lambda_1*m_1 );




