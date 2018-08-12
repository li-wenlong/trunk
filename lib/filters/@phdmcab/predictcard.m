function varargout = predictcard( this )

if isempty( this.predintensity )
    this.mupred = this.probbirth;
else
    this.mupred = this.predintensity.mu ;%+ this.probbirth;
    %this.mupred
end
this.predcard = poisspdf([0:length(this.postcard)-1], this.mupred )';

    
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
