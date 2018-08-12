function varargout = setID( this, ID )

if ~isnumeric(ID)
    error('The input should be a numeric value!');
else
    if prod(size(ID))~=1
        error('The input should be 1x1, i.e., a scalar!');
    end
end

this.ID = ID;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end