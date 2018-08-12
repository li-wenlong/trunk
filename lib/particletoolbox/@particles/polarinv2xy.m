function varargout = polarinv2xy( these, varargin )
% polarinv2xy transforms the states in  [theta 1/r thetadot rdot] to 
% [x y vx vy] 
% particles.polarinv2xy( C ) performs the transformation with respect to
% the coordinate system centre C = [c_x c_y c_xdot c_ydot]

numdims = these.getstatedims;
numpoints = these.getnumpoints;

trvector = zeros( numdims, 1 );% Coordinate system centre sensor
rotcenter = zeros( numdims, 1 ); % Centre of rotation in sensor coordinate systems
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

% First convert the inverse range to range
rs = 1./these.states(2,:);

% Then, convert polar coordinates 2 xy
[these.states(1,:), ys] = pol2cart( these.states(1,:), rs );
these.states(2,:) = ys;

% Find unit vectors in the direction of r
urs = unitvectors( these.states([1,2],:) );
% Find orthagonal vectors
uthetas = orthovectors( urs );

these.states([3,4],:) = uthetas.*repmat( these.states(3,:),2,1) + urs.*repmat( these.states(4,:),2,1);



% Add the coordinate centre; find states w.r.t. the coordinate centre
these = these.rotrans( 'translate', trvector, 'alpha', alpha_ );





if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end

end
function uv = unitvectors( x )

uv = x./repmat( sqrt( sum( x.*x , 1) ) , size(x, 1),1  );
end
function ov = orthovectors( x )

ov =  [-x(2,:);x(1,:)];
end