function [Cu, varargout] = grotcovmat( states, varargin )
% GROTcovmat Gaussian Rule-of-Thumb covariance matrix
iswarning = 0;
warningswitch = 1;

[nx Np] = size( states );
myeps = 1.0e-8;
w = ones( size(states, 2), 1)/Np;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin 
    switch lower(varargin{argnum})        
        case {'warningswitch'}
            if argnum + 1 <= nvarargin
                warningswitch = varargin{argnum+1};
                argnum = argnum + 1;
            end
        case {'weights'}
            if argnum + 1 <= nvarargin
                w = varargin{argnum+1}(:);
                w = w'/sum(w);
                argnum = argnum + 1;
            end
        case {'myeps'}
             if argnum + 1 <= nvarargin
                myeps = varargin{argnum+1}(:);
                argnum = argnum + 1;
            end
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
end




xdim = nx;



isreg = 0;
ischolok = 0;
maxtry = 100;
trycnt = 1;
while( isreg == 0 && trycnt<= maxtry )
    % Find the covariance matrix
    C = wcov( states, w );
    
    if rcond(C) > eps
        % the number of different states exceeds the number of dims.
        
        try
            R = chol(C)';
            ischolok = 1;
            break;
        catch
            if warningswitch
            warning(sprintf('Could not decompose C by chol(), proceeding with regularisation!'));
            end
            iswarning = 1;   
            
            isreg = 1;
            states = regularise( states );
        end
    else
        % possible particles deprivation
        if warningswitch
        warning(sprintf('Possibly less particles than the dims, assigning min. possible C!'));
        end
        iswarning = 2;
        
        C = myeps*eye(xdim);
        C = (C+C')/2; % take the symmetric part
        R = chol(C)';
        ischolok = 1;
        break;
    end
    trycnt = trycnt + 1;
end

if ischolok == 0
    if warningswitch
      warning(sprintf('Weird condition -- possible particle deprivation, assigning min. possible C!'));
    end
    iswarning = 3;
        
      C = myeps*eye(xdim);
      C = (C+C')/2; % take the symmetric part
      R = chol(C)'; 
end

Rinv = R^(-1);
Lambda_p = Rinv'*Rinv;
Wp = sqrtm(Lambda_p);% The whitening trasform

wstates = Wp*states; % Whiten the states

% For each dim of wstates, find the h
h_opt = rotbw( wstates, w );



% kernelType = 'Gauss';
% bwselection = 'rot';
% try
% kde_ = kde( wstates , bwselection,  w , kernelType  ); % Weights are scaled at constructor
% h_opt2 = getBW( kde_ );
% h_opt = h_opt2(:,1);
% end



h_opt( find(h_opt<=myeps ) ) = myeps;
% 
% if ~isempty( find(h_opt>1) )
%     h_opt( find(h_opt>1 ) ) = 1;
% end
% %aa = getBW(kde(wstates,'rot') );
% %h_opt = aa(:,1);

Lambda_u =  Wp'*diag( (1./(h_opt)).^2)*Wp ;
%Cu = inv( Lambda_u ); % updated covariance matrix
Wpi = Wp^(-1);
Cu = Wpi* diag( (h_opt).^2  ) *Wpi';

% if det(Cu)>det(C)
%     disp('NO!!!!!!!!!!!!!!!!')
%     h_opt
% else
%    disp('OK')
%    h_opt
% end

if nargout>=2
    varargout{1} = Lambda_u;
end
if nargout>=3
    varargout{2} = iswarning;
end
end
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

