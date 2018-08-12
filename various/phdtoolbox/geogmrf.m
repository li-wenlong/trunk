function [varargout] = geogmrf(E, tau, alpha )
% [C, Cinv] = geogmrf(E, tau, alpha)
% GEOGMRF Geostatistic Gaussian Markov Random Field returns the correlation
% matrix of a Gaussian Markov Random Field in accordance with the
% geostatistic model in accordance with the edge set E and the covariance matrix
% C = (I - \alpha*B)^-1 M
% where M = diag(tau)
% 0<= \alpha <=1, \sum_j b_{ij} = 1, b_{ij}tau_j = b_{ji}tau_i and 
% b_{ii} = 0 and b_{ij} = 0 unless i and j are neigbors in the edge set E,
% corresponding to local markov distributions
% Z_i | Z_j ~ N( \mu_i + \alpha\sum_{j=1}^n b_{ij}(Z_j - \mu_j), tau_i )
% which turns to
% Z_i | Z_j ~ N( \mu_i + \alpha\sum_{j \in ne(i)} b_{ij}(Z_j - \mu_j), tau_i )
%
% [C, Cinv, L ] = geogmrf(E, tau, alpha) returns the cholesky factor of C
% such that C = L*L';
%
% !!! This function is not ready !!!
%   See also GAUSSCOND, GAUSSMARG, GGM, GKLD

% Murat UNEY

% For arbitrary tau I could not find the algorithm
if nargin<3
    error('Not enough input arguments!');
elseif nargin==3
    if ~isnumeric( E ) | ~isnumeric(tau) | ~isnumeric(alpha)
        error('All three arguments should be of type numeric!');
    end
    tau = tau(:);
    if ndims(E)~=2
        error('The edge set E should be a two-dim. array of edges');
    end  
    alpha = alpha(1);
elseif nargin>3
    error('Too many input arguments');
end

%M = diag(tau);
numNodes = length(tau);
nodes = [1:numNodes]';
B = zeros(numNodes,numNodes);
BB = B;
E = sue(E);

for i=1:numNodes
    nei =unique( [E( find( E(:,1) == i),2); E( find( E(:,2) == i ), 1) ],'legacy'); 
    BB(i, nei ) = 1;
    BB(nei, i) = 1;
%     if ~isempty(nei)
%         bEntries = B(i, nei );
%         zeroBs = find( bEntries == 0 );
%         if ~isempty( zeroBs )
%             sumB = sum( bEntries );
%             bEntries(zeroBs) = (1 - sumB)/length(zeroBs);
%             
%             B(i, nei ) = bEntries;
%             B(nei(zeroBs), i ) = tau(nei(zeroBs)).*(bEntries(zeroBs)')/ tau( i );
%         end
%     end
end
%for i=1:numNodes
%    BB(i,:) =  BB(i,:)/sum( BB(i,:));
%end
B = BB;
%B = (BB*M + M'*BB')/2;
% for i=1:numNodes
%     fixSum = sum( B(1:i,) )
%     colsum = sum( B(i,:) );
    

% stat = checkB( B, tau);

% Cinv = (eye(numNodes)-alpha*B)/tau(1);
Cinv = (diag(sum(B,2))-alpha*B).*(repmat(1./tau(:),1, numNodes ))'; %diag(tau)^(-1); % /tau(1);
% Cinv = ( eye(numNodes)*max(sum(B,2))-alpha*B)/tau(1);

% sum(sum( abs(Cinv-Cinv').^2))/numNodes/numNodes
Cinv = (Cinv+Cinv')/2;
[V,D] = eig(Cinv);
eigs  = diag(D);
defEigs = find( eigs <eps);
if ~isempty( defEigs)
    eigs(defEigs) = 1.0e-16;
    D = diag(eigs);
    Cinv = V*D*V';
end 

R = chol(Cinv);
Rinv = R^(-1);
C = Rinv*Rinv';

varargout{1} = C;
varargout{2} = Cinv;
if nargout == 3
    varargout{3} = Rinv;
end

function stat = checkB(B, tau)
% stat = 0 : OK
% stat = 1 : B is not square
% stat = 2 : B has non zero diagonal entry
% stat = 3 : Col sums of B is not 1
% stat = 4 : b_{ij}tau_j ~= b_{ji}tau_i
[M, N]= size(B);
if M ~=N
    stat = 1;
    return;
end

for i=1:M
    if abs( B(i,i) )>eps
        stat = 2;
        return;
    end
    % check sum over the cols.
    nei = find( B(i,:)~=0 );
    colSum = sum( B(i,nei));
    if abs( colSum-1)>eps
        stat = 3;
        return;
    end
    for j=1:length(nei)
        if abs( B(i, nei(j))*tau(nei(j))-B(nei(j), i)*tau(i))>eps
            stat = 4;
            return;
        end
    end
end

    


        
        
    