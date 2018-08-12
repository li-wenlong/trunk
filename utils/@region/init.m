function varargout = init( this, varargin )

nvarargin = length(varargin);
argnum = 1;
isspec = 0;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'circular'}
                if argnum + 2 <= nvarargin
                    centre = varargin{argnum+1}(:);
                    argnum = argnum + 1;
                    radius = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                    type = 0;
                    isspec = 1;
                else
                    error('Not enough arguments to define a circular region...');
                    
                end
            case {'polygon'}
                if argnum + 1 <= nvarargin
                    pnts = varargin{argnum+1};
                    if size(pnts,2) <= 2
                        error('Not enough points to define a polygon' );
                    end
                    type = 1;
                    isspec = 1;
                else
                    error('Not enough arguments to define a region');
                end
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        pnts = varargin{argnum};
        if size(pnts,2) <= 2
            error('Not enough points to define a polygon' );
        end
        type = 1;
        isspec = 1;
    end
    argnum = argnum + 1;
end

if isspec == 0;
    error('Not enough arguments to define a region');
end
this.type = type;
if type == 0
    % circular
    this.r = radius;
    this.c = centre;
else
    this.vertices = pnts;
end
    
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
