function [bws, states, varargout] = grotns( states, varargin )

iswarning = 0;
warningswitch = 1;
w = ones( size(states, 2), 1);

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
                w = varargin{argnum+1};
                argnum = argnum + 1;
            end
        case {''}
            
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
end

myeps = 1.0e-8;

[nx Np] = size( states );
xdim = nx;



isreg = 0;
ischolok = 0;
maxtry = 100;
trycnt = 1;
while( isreg == 0 && trycnt<= maxtry )
    C = cov( states');
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

wstates = Wp*states;

% For each dim of wstates, find the h
h_opt = rotbw( wstates );
h_opt( find(h_opt<=myeps ) ) = myeps;
%aa = getBW(kde(wstates,'rot') );
%h_opt = aa(:,1);

bw_ = inv( Wp'*diag( (1./h_opt).^2)*Wp );

bws = repmat( bw_ ,[1, 1,Np ]);
if nargout>=3
    varargout{1} = iswarning;
end
