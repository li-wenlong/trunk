function varargout = setacceleration( this,  varargin )
% Set acceleration
if nargin == 2
    a = varargin{1};
    if ~ (isnumeric(a) && ndims(a) == 2 && prod(size(a))== 3 )
        error(sprintf('The input should be a 3x1 vector or a field name followed by a scalar.'));
    end
elseif nargin >= 3
    a = this.acceleration;
    for i=1:2:length(varargin)
        switch ( varargin{i} )  
            case this.accelerationlabels{1},
                ind = 1;
            case this.accelerationlabels{2},
                ind = 2;
            case this.accelerationlabels{3},
                ind = 3;
            otherwise
                error(sprintf('Unidentified field name!'));
        end
        
        val = varargin{i+1}(1);
        if ~isnumeric(val)
            error('The field name must be followed by a scalar');
        end
        
        a( ind ) = val;
    end
end

this.acceleration = a;

R_be = dcm( this.orientation );

this.accelearth = R_be'*this.acceleration;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end