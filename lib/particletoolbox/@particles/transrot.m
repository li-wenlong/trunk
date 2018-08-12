function varargout = transrot( these, varargin )

numdims = these.getstatedims;
numpoints = these.getnumpoints;

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

% First, translate
these.states = these.states + repmat( trvector, 1, numpoints ) ;
% Then, rotate
these.states = M*( these.states - repmat( rotcenter, 1, numpoints ) ) + repmat( rotcenter, 1, numpoints ) ;

% Rotate the BWs
% If y = Rx
% Then Cy = R Cx R'
if ~isempty( these.bws )
these.bws = lmmatarray( rmmatarray( these.bws, M'), M );
these.C = these.bws;
these.S = lmmatarray( rmmatarray( these.S, M'), M );
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
