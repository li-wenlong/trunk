function [Cs, states, varargout] = grotcovmat( states, varargin )
% GROTNS Gaussian Rule-of-Thumb covariance matrix
iswarning = 0;
warningswitch = 1;

[nx Np] = size( states );

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
        case {''}
            
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
end

myeps = 1.0e-8;


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
            states = regularise( states ); % This ones resamples from a second order approximation built
            % by replacing zero valued eigenvalues with eps.
        end
    else
        % possible particles deprivation
        if warningswitch
        warning(sprintf('Possibly less particles than the dims, adding small increments to the weights'));
        end
        iswarning = 2;
        
        w = reweightdeff( w, states );
        
%         C = myeps*eye(xdim);
%         C = (C+C')/2; % take the symmetric part
%         R = chol(C)';
%         ischolok = 1;
%         break;
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
if ~isempty( find( isnan(Cu) ==1)) || ~isempty( find( isinf(Cu) ==1))
    save weird2.mat
    error('NaN or Inf in the covariance matrix, workspace saves in weird2.mat');
end

if ~isreal(Cu)
    save weird3.mat
    error('Complex entry in the covariance matrix, workspace saves in weird3.mat');
end

% if det(Cu)>det(C)
%     disp('NO!!!!!!!!!!!!!!!!')
%     h_opt
% else
%    disp('OK')
%    h_opt
% end

Cs = repmat( Cu ,[1, 1,Np ]);
Ls = repmat( Lambda_u ,[1, 1,Np ]);
if nargout>=3
    varargout{1} = Ls;
end
if nargout>=4
    varargout{2} = iswarning;
end
