function varargout = remclutter(this, Zb)
% sensor.remclutter removes the clutter from the sensor reports stored 
% in the srbuffer field of the sensor object.

srs = this.srbuffer ;% Take sensor reports
srs.remclutter;
this.srbuffer = srs;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
