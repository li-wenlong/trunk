function varargout = setperspostintensity(this, particles )
% GETPERSPOSTINTENSITY returns the persistent particles representing the posterior intensity.
%
if ~isempty( particles )

% Pull the index of the persistent particles
indx1 = this.postintensity.getindx( 'p' );

notindx1 = setdiff( [ 1:length(this.postintensity) ], indx1 );
if length(indx1)~= length(particles)
    warning('Exchanging %d persistent particles with %d!', length(indx1), length(particles) );
end


this.postintensity = [this.postintensity(notindx1), particles ];
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
