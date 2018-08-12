function varargout = permz(this, Zb)
% sensor.permz reorders the measurements (Zs) in accordance with a random 
% of their indexes permutation

srs = this.srbuffer(2:end) ;% Take sensor reports
srs = srs.permz;
this.srbuffer(2:end) = srs;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
