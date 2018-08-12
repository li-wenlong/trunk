function varargout = xy2polarinv( these, varargin )
% xy2polarinv transforms the states in [x y vx vy] to 
% [theta 1/r thetadot rdot] 
% particles.xy2polarinv( 'translate', C ) performs the transformation with 
% respect to the coordinate system centre C = [c_x c_y c_xdot c_ydot]

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

% First, find states w.r.t. the sensor coordinates
these = these.transrot('translate', trvector, 'alpha', alpha_ );


% Find unit vectors in the direction of r
urs = unitvectors( these.states([1,2],:) );
% Find orthagonal vectors
uthetas = orthovectors( urs );
% Convert the x-y fields to polar coordinates
[ these.states(1,:), rs] = cart2pol( these.states([1],:) ,these.states([2],:) );
these.states(2,:) = 1./rs;

vthetas = sum( uthetas.*these.states([3,4],:), 1 );

vrs = sum( urs.*these.states([3,4],:), 1 );

these.states([3],:) = vthetas';
these.states([4],:) = vrs';





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