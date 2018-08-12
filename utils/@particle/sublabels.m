function outpars = sublabels( inpars, labels )
outpars = inpars;
for i=1:length( inpars )
    if isa( labels, 'cell')
        if length(labels)==1
            outpars(i).label = labels(1);
        else
            outpars(i).label = labels(i);
        end
    else
        if length(labels)==1
            outpars(i).label = {labels(1) };
        else
            outpars(i).label = {labels(i)};
        end
    end
end
  
 
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),outpars);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = outpars;
end            
  