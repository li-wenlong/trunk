function varargout = inchist( p1, varargin )

ind = [1:p1.numparticles];

if nargin>=2
    ind = varargin{1};
end

p1.histlen(ind) = p1.histlen(ind) + 1;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),p1);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p1;
end