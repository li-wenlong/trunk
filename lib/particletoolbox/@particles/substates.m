%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBSTATES
function varargout = substates( p, states )

if isnumeric(states)
    if ndims(states)>2
        error('The state array should be of dim.s 2 or less!');
    end
    [M, N] = size( states );
    [P, R] = size( p.states );
    if P~=0 || R~=0
        % If we already have some state entries
        if P ~= M
            error('Can not replace state arrays of different dim.s!');
        end
        if R ~= N
            error('Can not replace state arrays of different lenghts!');
        end
    end
    
    if  N == 1
        % We have a single Mx1 state vector
        p.states = states(:);
    else
        p.states(1:M,1:N) = states;
    end
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



% EO SUBSTATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%