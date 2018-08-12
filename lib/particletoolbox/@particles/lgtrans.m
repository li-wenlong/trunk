function varargout = lgtrans(inpar, F, varargin )

Q = eye(size(F));

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
     if isa( lower(varargin{argnum}), 'char')
         switch lower(varargin{argnum})
                      
             case {''}
                 
                 
             otherwise
                 error('Wrong input string');
         end
     else
         Q = varargin{ argnum };
     end
     argnum = argnum + 1;
end

inpar.states = F*inpar.states + sqrtm( Q )*randn( size(inpar.states) );

 if ~isempty( inpar.bws )
     for k=1:size( inpar.bws,3)
         dd = size(inpar.bws,1);% dimensionality of the bandwidth part
         inpar.bws([1:dd],[1:dd],k) = Q([1:dd],[1:dd]) + F([1:dd],[1:dd])*inpar.bws([1:dd],[1:dd],k)*F([1:dd],[1:dd])';
         
         if ~isempty( inpar.C )
         inpar.C([1:dd],[1:dd],k) = Q([1:dd],[1:dd]) + F([1:dd],[1:dd])*inpar.C([1:dd],[1:dd],k)*F([1:dd],[1:dd])';
         end
         if ~isempty( inpar.S )
         inpar.S([1:dd],[1:dd],k) = inv( inpar.C([1:dd],[1:dd],k) ); % Use the matrix
         end
%         inversion lemma for a faster inversion
%         %inpar.bws([1,2],[1,2],k) = Q([1,2],[1,2]) + F([1,2],[1,2])*inpar.bws([1,2],[1,2],k)*F([1,2],[1,2])';
     end
 end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), inpar );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = inpar;
end