% This script finds the EMD weights considering the decomposition of the KLD 
% of the true dist. to the EMD as given in Heskes paper
% This decomposition involves an unknown part as a sum of the KLDs of the
% true dist. to the individual posteriors minus a term which is further
% decomposed.
% Below is for (approx.) maximisation of this minus term.
% D is generated in a random fashion. sometimes the exponents are negative
% and I am not sure if that could be the case with a realistic D matrix.


% Let D denote the matrix of mutual KLDs for N posteriors:

% D = [0 0.2 0.1;0.5 0 0.3; 0.2 0.1 0];
D = [0 0.2 0.1 0.3;0.5 0 0.3 0.1; 0.2 0.1 0 0.2; 0.2 0.2 0.2 0];

% [m,n] = size(D);

R = rand(5);
for i=1:size(R,2);R(i,i) = 0 ; end;
D = R ;

Ds = ( D + D' )/2 ; % Symmetric part of D

T = eye(m);
T(1,2:end) = -1;

J = T'*Ds*T;

c1 = J(2:end,1);
C = J(2:end,2:end);

Pinv = (C'*C)^(-1)*C'; % Pseudo inverse

wtilde = -Pinv*c1

disp('gradient vector at [1 w]'':')
J*[1;wtilde]
disp('w''*J*w')
[1;wtilde]'*J*[1;wtilde]
disp('EMD coefficients:')
T*[1;wtilde]
