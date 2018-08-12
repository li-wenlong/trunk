function h = rotbw( ws, varargin )

isweighted = 0;
if nargin>=2
    w = varargin{1}(:);
    w = w/sum(w);
    isweighted = 1;
end



[nx N] = size( ws );

for i=1:nx
    if isweighted
       sig  =  sqrt( var( ws(i,:), w' ) );
       
      % med = wmedian( ws(i,:), w' );
      % sig = wmedian( abs(ws(i,:)-med), w') / 0.6745;
    else
        
    med = median( ws(i,:) );
    sig = median(abs(ws(i,:)-med)) / 0.6745;
    end
    if sig<=0, sig = max( ws(i,:) )-min( ws(i,:) ); end
   if sig>0
      % Default window parameter is optimal for normal distribution
      h(i) = sig * (4/(3*N))^(1/5);
   else
      h(i) = 1;
   end
end

h = h(:);
end
function wMed = wmedian(D,W)

% ----------------------------------------------------------------------
% Function for calculating the weighted median 
% Sven Haase
%
% For n numbers x_1,...,x_n with positive weights w_1,...,w_n, 
% (sum of all weights equal to one) the weighted median is defined as
% the element x_k, such that:
%           --                        --
%           )   w_i  <= 1/2   and     )   w_i <= 1/2
%           --                        --
%        x_i < x_k                 x_i > x_k
%
%
% Input:    D ... matrix of observed values
%           W ... matrix of weights, W = ( w_ij )
% Output:   wMed ... weighted median                   
% ----------------------------------------------------------------------


if nargin ~= 2
    error('weightedMedian:wrongNumberOfArguments', ...
      'Wrong number of arguments.');
end

if size(D) ~= size(W)
    error('weightedMedian:wrongMatrixDimension', ...
      'The dimensions of the input-matrices must match.');
end

% normalize the weights, such that: sum ( w_ij ) = 1
% (sum of all weights equal to one)

WSum = sum(W(:));
W = W / WSum;

% (line by line) transformation of the input-matrices to line-vectors
d = reshape(D',1,[]);   
w = reshape(W',1,[]);  

% sort the vectors
A = [d' w'];
ASort = sortrows(A,1);

dSort = ASort(:,1)';
wSort = ASort(:,2)';

% sumVec = [];    % vector for cumulative sums of the weights
% for i = 1:length(wSort)
%     sumVec(i) = sum(wSort(1:i));
% end
sumVec=cumsum(wSort);

wMed = [];      
j = 0;         

while isempty(wMed)
    j = j + 1;
    if sumVec(j) >= 0.5
        wMed = dSort(j);    % value of the weighted median
    end
end


% final test to exclude errors in calculation
if ( sum(wSort(1:j-1)) > 0.5 ) & ( sum(wSort(j+1:length(wSort))) > 0.5 )
     error('weightedMedian:unknownError', ...
      'The weighted median could not be calculated.');
end

end