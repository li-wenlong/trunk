function varargout = prunemeas( these , pd )


numdets = [];
tlist = [];
for i=1:length(these)
    tind = find( these(i).given ~= 0 );
    
    if ~isempty(tind)
        u = rand(size(tind)); 
        prtargind = find( u > pd ); % Prune these ones
        
        firstap = setdiff(  these(i).given(tind), tlist );
        if ~isempty(firstap)
            % These targets appear for the first time and should be
            % detected with prob. 1
            for j=1:length(firstap)
               ftind = find( these(i).given == firstap(j) );
               prtargin = setdiff( prtargind, ftind ); 
            end            
        end
        remind = setdiff([1:length(these(i).given)], tind(prtargind) );
        
        tlist = union( tlist, these(i).given(tind) );      
        
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
