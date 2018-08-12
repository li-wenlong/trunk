function varargout = update( this, sensor , varargin )


% Update the persistent particles
[this, parlhood] = this.updateintensity(sensor, varargin{:} );

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
     if nargout>=2
        varargout{2} = parlhood;
    end
end
