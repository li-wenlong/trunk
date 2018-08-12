function this = subsnbintensity(this, pint )
% SUBSNBINTENSITY substitues a new born target intensity into the filter object

this.nbintensity = pint;
this.munb = pint.mu;
this.cardnb = poisspdf([0:length(this.cardnb)-1], this.munb)';



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
