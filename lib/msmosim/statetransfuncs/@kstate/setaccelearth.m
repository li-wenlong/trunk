function varargout = setaccelearth( this,  varargin )
% Set acceleration in earth fixed coordinate system
labels = kstatelabels;
if nargin == 2
    ae = varargin{1}(:);
    if ~ (isnumeric(ae) && ndims(ae) == 2 && prod(size(ae))== 3 )
        error(sprintf('The input should be a 3x1 vector or a field name followed by a scalar.'));
    end
elseif nargin >= 3
    ae = this.accelearth;
    for i=1:2:length(varargin)
        switch ( varargin{i} )  
            case labels.accelearthlabels{1},
                ind = 1;
            case labels.accelearthlabels{2},
                ind = 2;
            case labels.accelearthlabels{3},
                ind = 3;
            otherwise
                error(sprintf('Unidentified field name!'));
        end
        
        val = varargin{i+1}(1);
        if ~isnumeric(val)
            error('The field name must be followed by a scalar');
        end
        
        ae( ind ) = val;
    end
end

this.accelearth = ae;

R_be = dcm( this.orientation );

this.acceleration = R_be*this.accelearth;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end