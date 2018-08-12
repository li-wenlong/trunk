function varargout = update( this, sensor )


% Update the persistent particles
this = this.updateintensity(sensor);

% For now, the cardinality is updated in the intensity update method and
% the line below is commented out
% this = this.updatecard(sensor);

   

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
