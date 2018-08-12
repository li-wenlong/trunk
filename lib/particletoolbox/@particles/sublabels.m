function varargout = sublabels( inpars, labels )


% The label tags
% -inf = New born
%  inf = persistent
%  NaN = 
if ~isnumeric(labels)
    error('The labels can only be numerical values!')
end



if length(labels)==1
    if ~isempty(inpars.weights)
        
        inpars.labels(1:length(inpars.weights)) = labels(1);
        
    else
        error('The weights of the states must be assigned before the labels!');
    end
else
    % If we have N many labels, there must be one for each state:
    if length(labels(:)) == size( inpars.states, 2 )
        inpars.labels = labels(:);
    else
        error('The number of labels and the number of states differ!');
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
  