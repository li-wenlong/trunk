function varargout = regwkde( these, varargin )

sig_ = 0;
nvarargin = length(varargin);
dims = [1:size(these.states,1)];

argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {''}
                
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    if isnumeric(varargin{argnum+1})
                        dims = varargin{argnum+1}(:);
                    elseif strcmp( lower(varargin{argnum+1}), 'all' )
                        dims = [1:size(p.states,1)];
                    else
                        error('Wrong input after keywork dims!');
                    end
                    argnum = argnum + 2;
                end
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        sig_ = varargin{argnum};
    end
    argnum = argnum + 1;
end

[nx Np] = size( these.states(dims, :) );
xdim = nx;
gauss_mat = randn(nx,Np);

if xdim == 2
    A = 0.96;
else
    A = (4/(2*nx+1))^(1/(nx+4)); 
end

h_fact = A*Np^(-1/(nx+4));
 
if ndims( these.bws ) == 3
    for i=1:size( these.states , 2)
%         if these.labels(i) == 0
%             continue;
%         end
        sigs = eig( these.bws(dims,dims,i) );
        try
            R = chol( these.bws(dims,dims,i) )';
            
        catch
            R = zeros(xdim,xdim) ;
        end

        if length(sig_) == 1
            these.states(dims,i) = these.states(dims,i) + ( R + h_fact*sig_*diag(sigs/sum(sigs)))*gauss_mat(:,i);
        else
            gainvec = sig_(:);
            diagel  = gainvec.*( sigs/sum(sigs));
            if length(sig_)>3 && length(sig_)<=4
            diagel([3,4]) = sig_([3 4]);
            end
  
            these.states(dims,i) = these.states(dims,i) + ( R + h_fact*diag(diagel) )*gauss_mat(dims,i) ;   
        

        end

    end
elseif ndims( these.bws ) == 2 
    if size( these.states , 2)>1
        for i=1:size( these.states , 2)
%             if these.labels(i) == 0
%              continue;
%             end
        
            these.states(:,i) = these.states(:,i) + ( chol( diag( these.bws(:,i) ) )' + sig_*h_fact*eye(xdim) )*gauss_mat(:,i) ;
        end
    else
        % There is a single particle,
        try
            R = chol( these.bws )';
            
        catch
            R = zeros(xdim,xdim) ;
        end
        sigs = eig( these.bws );
        these.states(:,1) = these.states(:,1) + ( R + sig_*h_fact*diag(sigs/sum(sigs)))*gauss_mat(:,1) ;
        
    end
end

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end
