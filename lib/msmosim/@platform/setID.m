function varargout = setID( this, ID )

if ~isnumeric(ID)
    error('The input should be a numeric value!');
else
    if prod(size(ID))~=1
        error('The input should be 1x1, i.e., a scalar!');
    end
end

this.ID = ID;
this.track.ID = ID;

basenum = (ID +100)*10^3*10^3;

% set IDs of the sources
for i=1:length(this.sources)
    this.sources{i} = this.sources{i}.setID( basenum + 100 + i );
end

% set IDs of the sensors 
for i=1:length(this.sensors )
    this.sensors{i} = this.sensors{i}.setID(basenum + (100+i)*10^3 );
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