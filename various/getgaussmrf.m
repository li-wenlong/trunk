function px = getgaussmrf( V, E, varargin )
% function gaetgaussmrf returns a gk object which is a Markov random field
% px = getgaussmrf( V, E, m, dim, 0.75 ) returns
%

V = unique( E(:) ,'legacy');

ismu = 0;
if nargin>=3
    mu = varargin{1}(:);
    ismu = 1;
end

dim = 1;
if nargin>=4
    dim = varargin{2};
end

omega = 0.75;
if nargin>=5
    omega = varargin{3};
end

if ~ismu
    N = length( V ); % number of nodes
    numVar = N*dim; % number of variables
    mu = zeros( N*dim, 1);
end

% This is
Lambda_theta = eye(length(V)*dim);

Lambda = zeros(length(V)*dim);
Check = zeros( length(V) );

for i=1:length(V)
    % pick the next node
    v = V(i);
    % find its neighbours
    n = nei( E, v );
    
    % Find the indices of the fields of v
    vind = [ (v-1)*dim+1:(v)*dim];
    % pick mu_1 from the mean vector
    mu1 = mu( vind);
    
    for j=1:length(n)
        % for all neighbours, create 
        nj = n(j);
        
        % Find the indices of the fields of n
        nind = [ (n(j)-1)*dim+1:n(j)*dim ];
        % pick the neighbour's mean
        mu2 = mu( nind);
        
           
        Lambda( [vind, nind], [vind, nind] ) = [2*eye(dim) -2*eye(dim);-2*eye(dim) 2*eye(dim)];
        
    end
end
Lambda = ( Lambda + Lambda')*0.5;
Lambda_x = (omega)*Lambda + Lambda_theta;
R = chol(Lambda_x)';
Rinv = R^(-1);
%     % Construct the inverse covariance
C_x = Rinv'*Rinv;

px = cpdf( gk( C_x, mu ) );