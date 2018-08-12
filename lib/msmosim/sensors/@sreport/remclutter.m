function varargout = remclutter( these , varargin )


numdets = [];
for i=1:length(these)
    cind = find( these(i).given == 0 );
    remind = setdiff([1:length(these(i).given)], cind);
    these(i).Z = these(i).Z(remind);
    these(i).given = these(i).given(remind);
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
