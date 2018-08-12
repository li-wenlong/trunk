function varargout = subbw( p, bws )

if isnumeric(bws)
    if ndims(bws)>2
        error('Sorry -- cov. matrix per particle is not supported yet');
    end
    [M, N] = size( bws );
    [P, R] = size( p.states );
    
    if M==1 || N==1 
        if M==1
            bws = repmat(bws, P,1);
        end
        if N==1
            bws = repmat(bws, 1, R);
        end
        [M, N] = size( bws );
    end
    if P ~= M ||  R ~= N
        error('The bandwidth array should be of size DxN for a DxN state array!');
    end
      
    p.bws = bws;
    
else
    error('State should be a numeric array!');
end
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1), p);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p;
end
