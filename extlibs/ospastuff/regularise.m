function py = regularise(px,model)
%
py = px;
[nx Np] = size(px);
xdim = nx;
% this is nx=4 only
A = (4/(nx+2))^(1/(nx+4));
h_fact =  A * Np^(-1/(nx+4));
C = cov(px');

[V, D] = eig(C); % C = V*D*V'
eigvalues = diag(D);

eigvalues( find( eigvalues<eps  ) ) = max( eigvalues )*eps;
Dc = diag( eigvalues );

% Conditioned covariance matrix
Cc = V*Dc*V';
Am = chol(Cc)';

gauss_mat = randn(nx,Np);

py = px + 0.1 * h_fact * Am *gauss_mat;
