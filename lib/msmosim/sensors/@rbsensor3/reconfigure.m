function varargout = reconfigure( this, cfg )

if ~isa( cfg, 'rbsensor3cfg' )
    error('Unknown configuration object!');
end
    
that = rbsensor3( cfg );
 
that.ID = this.ID;
that.time = this.time;
that.srcbuffer = this.srcbuffer;
that.srbuffer = this.srbuffer;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),that);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = that;
end


