function varargout = rotrans( these, varargin )

numdims = these.getdims;
numcomps = length( these );

trvector = zeros( numdims, 1 );
rotcenter = zeros( numdims, 1 );
alpha_ = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'centre','center'}
                rotcenter =  varargin{argnum+1};
                argnum = argnum + 1;
                
            case {'translate'}
                trvector =  varargin{argnum+1};
                argnum = argnum + 1;
             case {'alpha'}
                alpha_ =  varargin{argnum+1};
                argnum = argnum + 1;  
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        
    end
    argnum = argnum + 1;
end

R = rotmat2d( alpha_ );
M = [];
for cnt =1:2:numdims
    M = [M, zeros( size(M,1), size(R,2) ); zeros(size(R,1), size(M,2) ), R];
end

for i=1:numcomps
    % first, rotate
    these(i) = gk( M*these(i).C*M' , M*( these(i).m - rotcenter ) + rotcenter );
    % then, translate
    these(i).m = these(i).m + trvector;
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
