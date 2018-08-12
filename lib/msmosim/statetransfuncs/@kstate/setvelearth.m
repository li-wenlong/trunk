function varargout = setvelearth( this, varargin )
% Set velocity vector in earth coordinate system
labels = kstatelabels;
if nargin == 2
    ve = varargin{1}(:);
    if ~ (isnumeric(ve) && ndims(ve) == 2 && prod(size(ve))== 3 )
        error(sprintf('The input should be a 3x1 vector or a field name followed by a scalar.'));
    end
elseif nargin >= 3
    ve = this.velearth;
    for i=1:2:length(varargin)
        switch ( varargin{i} )  
            case labels.velearthlabels{1},
                ind = 1;
            case labels.velearthlabels{2},
                ind = 2;
            case labels.velearthlabels{3},
                ind = 3;
            otherwise
                error(sprintf('Unidentified field name!'));
        end
        
        val = varargin{i+1}(1);
        if ~isnumeric(val)
            error('The field name must be followed by a scalar');
        end
        
        ve( ind ) = val;
    end
end

this.velearth = ve;

R_be = dcm( this.orientation );

this.velocity = R_be*this.velearth;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end