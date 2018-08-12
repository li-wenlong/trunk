function varargout = biasbuffer(this, Zb)
% sensor.biasbuffer(Zb) adds Zb to each of the measurements in the sensor
% report buffer stored in the srbuffer field of the sensor object.

srs = this.srbuffer ;% Take sensor reports
for i=1:length( srs )
    Ztu = srs(i).Z; 
    Ztb = Ztu + Zb;
    srs(i).Z = Ztb;
end

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
