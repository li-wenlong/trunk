function px = getgaussmrf( V, E, varargin )
% function gaetgaussmrf returns a gk object which is a Markov random field
% px = getgaussmrf( V, E, m, dim, 0.75 ) returns
%

V = unique( E(:),'legacy' );

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
Lambda_theta = eye(length(V)*dim)*(omega);

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
        
        if Check( nj, v )~=0
            % this entry will be the same with that for (v,nj)
            continue;
        end
        % Find the indices of the fields of n
        nind = [ (n(j)-1)*dim+1:n(j)*dim ];
        % pick the neighbour's mean
        mu2 = mu( nind);
        
        % Find a transform that has mu2 in its null space
        e2 = mu2*mu2'/(mu2'*mu2);
        Q2 = eye(dim) - e2;
        
        Lambda12 = Lambda( vind, nind );
        % mu2 should be in the null space of Lambda12
        Lambda12 = Lambda12 + Q2;
        Lambda( vind, nind ) = Lambda12;
        Check( v, nj ) = 1;
    end
end
Lambda = ( Lambda + Lambda')*0.5;
Lambda_x = (1-omega)*Lambda/max(max(Lambda)) + Lambda_theta;
R = chol(Lambda_x)';
Rinv = R^(-1);
%     % Construct the inverse covariance
C_x = Rinv'*Rinv;

px = cpdf( gk( C_x, mu ) );