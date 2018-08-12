function these = getel( these, p1, s )

if ~isnumeric(s)
    error('The argument should be an index array!');
end

these.states(:, s(:) ) = p1.states(:, : );
these.weights( s(:) ) = p1.weights( : );
these.labels( s(:) ) = p1.labels( : );

if ~isempty( p1.blmap )
    these.blmap = p1.blmap;
end
if ~isempty( p1.blabels )
    these.blabels(:, s(:) ) = p1.blabels(:, :);
end

these.ispersistent( s(:) ) = p1.ispersistent( : );
these.histlen( s(:) ) = p1.histlen( : );
if ndims( p1.bws ) == 2 && ~isempty(p1.bws)
these.bws(:, s(:)) = p1.bws(:, :);
elseif ndims( p1.bws ) == 3 && ~isempty(p1.bws)
these.bws(:, :, s(:)) = p1.bws(:, :, :);
these.C(:, :, s(:)) = p1.C(:, :, :);
these.S(:, :, s(:)) = p1.S(:, :, :);
end



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end
