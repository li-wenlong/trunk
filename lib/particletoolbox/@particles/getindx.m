function varargout = getindx( particles, key )
 
if ~isnumeric(key)
    error('The search key must be a numerical value!');
end

for i=1:length(key)
    varargout{i} = find(particles.labels==key(i) );
end % for particle