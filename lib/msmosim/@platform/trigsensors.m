function varargout = trigsensors( this )



% Have all the sensors triggered to make measurements
for i=1:length( this.sensors )
   this.sensors{i}  = this.sensors{i}.measure( 'pstate', this.getkstate );
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
