function varargout = subhistlen( inpars, histlen )


if ~isnumeric( histlen )
    error('The History lenghts can only be numerical values!')
end



if length(histlen)==1
    if ~isempty(inpars.weights)
        
        inpars.histlen(1:length(inpars.weights)) = histlen(1);
        
    else
        error('The weights of the states must be assigned before the history lenghts!');
    end
else
    % If we have N many labels, there must be one for each state:
    if length(histlen(:)) == size( inpars.states, 2 )
        inpars.histlen = histlen(:);
    else
        error('The number of history lenghts and the number of states differ!');
    end
 
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1), inpars);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = inpars;
end
  