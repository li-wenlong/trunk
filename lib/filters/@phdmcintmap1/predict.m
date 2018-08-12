function varargout = predict( this, sensorobj )

% Predict the intensity
this = this.predictintensity(sensorobj);
% Predict the cardinality distribution
this = this.predictcard;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
