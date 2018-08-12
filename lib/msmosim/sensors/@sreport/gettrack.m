function varargout = gettrack( these, trindx )


numdets = [];
for i=1:length(these)
    these(i).Z = these(i).Z(trindx(i));
    these(i).given = these(i).given(trindx(i));
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
