function varargout = predict( this )


%disp(sprintf('This is predict intensity'));

% Remove the line below; it is used to inject a particle for testing
% this.postintensity = particle( 'state',[1 2 3 4],'weight',0.5, 'label', 'nb');

if ~isempty( this.post )
        this.pred = ...
        this.targetmodel.transtates( this.post );
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
