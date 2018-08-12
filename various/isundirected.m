function [l, varargout] = isundirected(E)
% ISUNDIRECTED checks whether a graph is undirected or not
% l = isundirected( E ) returns 1 when input a Nx2 array E listing the edges
% (i,j)s of a graph, and for all (i,j) in E, (j,i) is also in E.
% [l, i] = isundirected( E ) returns the indexes i of those edges which
% break the above condition for undirectedness.
%
% See also SUE, SNEI 
% Murat Uney

l = 1;
eind = []; % indices of edges that do not have their reverse in E
S = zeros(size(E,1),1);

for k=1:size(E,1)
    if S(k)~= 0
        % edge already verified to have its reverse in E
        continue;
    end
    % E(i,1:2) = (i,j)
    % Find the children of j, i.e., (j,k)s
    ind = find( E(k,2)== E(k:end,1) );
    % Is any of these nodes i?
    indi = find( E(k,1) == E( k-1+ind, 2 ) );
    if isempty( indi )
        % None of them of is i, (j,i) is not in E
        l = 0;
        eind = [eind;k];
    else
        % At least one of them is in i 
        % Take the first ind(indi(1)) and tag as 1 
        S(k) = 1;
        S( k-1 + ind(indi(1)) ) = 1;
    end    
end

if nargout>=2
    varargout{1} = eind;
end