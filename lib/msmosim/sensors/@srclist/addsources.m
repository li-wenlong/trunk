function varargout = addsources(this, src, time)

if ~isa( src, 'cell' )
    error('The input should be a cell array.');    
else
    for i=1:length(src)
       if ~isa( src{i} , 'source' )
          error('The entries of the cell array should be of type source.'); 
       end
    end
end 

if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time to proceed is a scalar!');
end
time = time(1);


this.src = src;
this.time = time;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
