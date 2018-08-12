function varargout = update( this, sensor, varargin )


% Update the persistent particles
[this, proddenom] = this.updateintensity(sensor, varargin{:} );

% The Poisson parameter which equals to the posterior expected number of
% targets is updated while the intensity is updated.
   

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
    if nargout>=2
        varargout{2} = proddenom;
    end
end
