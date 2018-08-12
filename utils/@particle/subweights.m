 function varargout = subweights( inpars, weights )
 outpars = inpars;
 
 islen1 = 0;
 if length(weights) == 1
     islen1 = 1;
 elseif length(weights)~= length( inpars )
     error('The weight array should be either of length of the particle array or of 1!');
 end
 
 for i=1:length(outpars)
    if ~islen1
        outpars(i).weight = weights(i);
    else
        outpars(i).weight = weights(1);
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