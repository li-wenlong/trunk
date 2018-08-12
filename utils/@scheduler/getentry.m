function varargout = getentry( this )

if this.firstcall == 0
    this.firstcall = 1;
end
output = [];
if this.counter <= length( this.pattern )

    if this.counter >= this.initime
        rowindx = mod( this.counter - this.initime , length(this.pattern) ) + 1;
        if rowindx<=length(this.pattern)
            output = this.pattern{rowindx};
        end
    end
    
else
    warning('End of pattern reached, returning the last entry');
    output = this.pattern{end};
end

this.counter =  this.counter + 1;
    
if nargout <=1
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
    varargout{1} = output;
else
    varargout{2} = this;
    varargout{1} = output;
end