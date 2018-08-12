function varargout = remsourceid( these , id )


numdets = [];
for i=1:length(these)
    for j=1:length(id)
    cind = find( these(i).given == id(j) );
    %if isempty(cind)
    %    warning(disp('Source id %d can not be found', id(j) ));
    %end
    remind = setdiff([1:length(these(i).given)], cind);
    these(i).Z = these(i).Z(remind);
    these(i).given = these(i).given(remind);
    end
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
