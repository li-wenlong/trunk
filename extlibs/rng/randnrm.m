function x = randnrm(n, m, S, V)
% RANDNORM      Sample from multivariate normal.
% RANDNORM(n,m) returns a matrix of n columns where each column is a sample 
% from a multivariate normal with mean m (a column vector) and unit variance.
% RANDNORM(n,m,S) specifies the standard deviation, or more generally an 
% upper triangular Cholesky factor of the covariance matrix.  
% This is the most efficient option.
% RANDNORM(n,m,[],V) specifies the covariance matrix.
%
% Example:
%   x = randnorm(5, zeros(3,1), [], eye(3));


% The polar form of the Box-Muller transformation is both faster and more robust numerically. The algorithmic description of it is: 
% 
%          float x1, x2, w, y1, y2;
%  
%          do {
%                  x1 = 2.0 * ranf() - 1.0;
%                  x2 = 2.0 * ranf() - 1.0;
%                  w = x1 * x1 + x2 * x2;
%          } while ( w >= 1.0 );
% 
%          w = sqrt( (-2.0 * ln( w ) ) / w );
%          y1 = x1 * w;
%          y2 = x2 * w;


if nargin == 1
    
  x = zeros(1,n);
  needMore = 1;
  lastInd = 1;
  
  while( needMore >=1 )
      rbuff = twister(2*n,2);
      
      x1 = 2.0*rbuff(:,1) - 1.0;
      x2 = 2.0*rbuff(:,2) - 1.0;
      
      w = x1.^2 + x2.^2;
      
      inds = find( w< 1.0 );
      if isempty(inds)
          continue;
      end
      w(inds) = sqrt( (-2.0 * log( w(inds) ) ) ./ w(inds) );
      xbuff(1:2:length(inds)*2) = x1(inds).*w(inds);
      xbuff(2:2:length(inds)*2) = x2(inds).*w(inds);
      
%       ind = find( xbuff<4 & xbuff>-4 );
%       disp(sprintf(' %d out of range samples \n',length(xbuff)-length(ind) ))
%       xbuff = xbuff(ind);
      
      finalInd = min( n , lastInd -1 + length( xbuff ) );
      x(lastInd:finalInd) = xbuff(1:finalInd-lastInd+1 ) ;
      
      lastInd = finalInd;
      if finalInd >= n
          needMore = 0;
      end
  end
  return;
end
[d,nm] = size(m);
x = reshape( randnrm(d*n), [d,n]);
if nargin > 2
  if nargin == 4
    if d == 1
      S = sqrt(V);
    else
      S = chol(V);
    end
  end
  if d == 1
    x = S .* x;
  else
    x = S' * x;
  end
end
if nm == 1
  x = x + repmat(m, 1, n);
else
  x = x + m;
end
