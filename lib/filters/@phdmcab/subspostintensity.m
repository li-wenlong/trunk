function this = subspostintensity(this, pint )
% SUBSPOSTINTENSITY substitues a posterior intensity into the filter object

if pint.mu == 0
    this.postintensity = phd;
    this.postintensity = this.postintensity([]);
else
    this.postintensity = pint;
    this.mupost = pint.mu;
end
this.postcard = poisspdf([0:length(this.postcard)-1], this.mupost)';



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
