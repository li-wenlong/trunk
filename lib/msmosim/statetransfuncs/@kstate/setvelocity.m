function varargout = setvelocity( this,  varargin )
% Set velocity
labels = kstatelabels;
if nargin == 2
    v = varargin{1}(:);
    if ~ (isnumeric(v) && ndims(v) == 2 && prod(size(v))== 3 )
        error(sprintf('The input should be a 3x1 vector or a field name followed by a scalar.'));
    end
elseif nargin >= 3
    v = this.velocity;
    for i=1:2:length(varargin)
        switch ( varargin{i} )  
            case labels.velocitylabels{1},
                ind = 1;
            case labels.velocitylabels{2},
                ind = 2;
            case labels.velocitylabels{3},
                ind = 3;
            otherwise
                error(sprintf('Unidentified field name!'));
        end
        
        val = varargin{i+1}(1);
        if ~isnumeric(val)
            error('The field name must be followed by a scalar');
        end
        
        v( ind ) = val;
    end
end

this.velocity = v;

R_be = dcm( this.orientation );

this.velearth = R_be'*this.velocity;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end