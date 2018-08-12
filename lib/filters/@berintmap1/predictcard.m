function varargout = predictcard( this )

this.predcard = zeros(length(this.postcard),1);

this.predcard(2) = this.nbintensity.mu*(1-this.postcard(2)) + this.probsurvive*this.postcard(2);

this.predcard(1) = 1-this.predcard(2);

this.mupred = this.predcard(2);


%disp( sprintf('The predicted cardinaltiy sums to %g',this.predcard(1) + this.predcard(2) ));
    
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
