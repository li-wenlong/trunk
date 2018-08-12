function varargout = setangularmoment( this,  varargin )
% Set angular moments
labels = kstatelabels;
if nargin == 2
    m = varargin{1};
    if ~ (isnumeric(m) && ndims(m) == 2 && prod(size(m))== 3 )
        error(sprintf('The input should be a 3x1 vector or a field name followed by a scalar.'));
    end
elseif nargin >= 3
    m = this.angularmoment;
    for i=1:2:length(varargin)
        switch ( varargin{i} )  
            case labels.angularmomentlabels{1},
                ind = 1;
            case labels.angularmomentlabels{2},
                ind = 2;
            case labels.angularmomentlabels{3},
                ind = 3;
            otherwise
                error(sprintf('Unidentified field name!'));
        end
        
        val = varargin{i+1}(1);
        if ~isnumeric(val)
            error('The field name must be followed by a scalar');
        end
        
        m( ind ) = val;
    end
end

this.angularmoment = m;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end