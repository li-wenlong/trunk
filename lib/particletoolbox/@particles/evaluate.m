function varargout = evaluate( par, varargin )

isReg = 0;
sig_ = 0;
p_ = [];
threshold = -20;
edistreshold = 500;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'regaddnoise'}
                if argnum + 1<= nvarargin
                    isReg = 1;
                    sig_ = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'threshold'}
                if argnum + 1<= nvarargin
                    threshold = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            
                
            case {'regularise'}
                isReg = 1;
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        p_ = varargin{argnum};
    end
    argnum = argnum + 1;
end

if isempty(p_)
    p_ = par.states;
end

if isReg
    par.regwkde(sig_);
end

if ndims(par.bws)==3 || size( par.states, 2) == 1
     
     
     N = size(p_, 2);
     D = size(p_, 1);
     w = zeros( 1, N);
     
     maxcontr = zeros(1, N);
     assoc = zeros(1, N);
     
     logassoc = zeros( 1, N);
     for i=1:size( par.states, 2)
        % loop over the kernels
        
        % find the dx of the evaluation points w.r.t. kernel i
         dx = p_ - repmat( par.states(:,i), 1, N);

         % Find the normalisation factor of kernel i
         sc = (2*pi)^(D/2) * sqrt( det(par.C(:,:,i) ) ); % normalising term (makes Gaussian hyper-volume equal 1)
         % Find the exponential terms for evaluating kernel i at evaluation
         % points
         E = -0.5 * sum( dx.*(par.S(:,:,i)*dx) ,1);                % exponential term
         % Find the Euclidean distances of the evaluation points to kernel
         % i
         sqed = sqrt( sum( dx.*dx ,1) ); % Euclidean distances
         
        
         % Find the contribution of kernel i to each evaluation point:
         
         % 1) Threshold the exp. terms to bound the number of calls to the
         % exp() function; treat those with less than threhold having zero
         % contribution
         ind = find(E>threshold);
         % 2) Evaluate kernel i at those points onto which the contribution
         % is non zero
         contr = par.weights(i)*(exp(E(ind)))/sc;
         
         % Find the log of the contributions for association purposes
         logcontr = log( par.weights(i)/sc ) + E;
         
         edistreshold = sqrt( max( eigs( par.C(:,:,i) ) ) )*5;
         if i==1
             % 
             assocptr = [1:N];
             
             assocptr2 = find( sqed(assocptr) < edistreshold );
             logassoc(assocptr(assocptr2)) = i;
             maxlogcontr = logcontr;
             
         else
             assocptr = find( logcontr > maxlogcontr );
             
             assocptr2 = find( sqed(assocptr) < edistreshold );
             
             logassoc(assocptr(assocptr2)) = i;
             maxlogcontr(assocptr(assocptr2)) = logcontr(assocptr(assocptr2));
         end
         
         
         % Below is the association based on the value of the contribution
         % itself rather than the log contribution. This leads to fewer
         % relations.
%          assocptr = find( contr > maxcontr(ind) );
%          
%          assocptr2 = find( sqed(assocptr) < edistreshold );
%          assoc(ind(assocptr(assocptr2) )) = i;
%          maxcontr(ind(assocptr(assocptr2) )) = contr(assocptr(assocptr2));
%        
         w(ind)  = w(ind) + contr;
     end
     
    % assoc = logassoc;
%  g.w = par.weights;
%      g.P = par.bws;
%      g.x = par.states;
%      w= gmm_evaluate(g,p_);

end

varargout{1} = w;
if nargout>=2
    varargout{2} = logassoc;
end
