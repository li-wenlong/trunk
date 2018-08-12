function E = adj2edge(A)
% ADJ2EDGE returns the edge set beared by the adjecancy matrix A
% E = adj2edge(A) is the set of edges corresponding to unity entries in the
% NxN matrix A.
%
%

% Murat Uney
if nargin~=1
    error('The argument should be a single NxN matrix!');
end
if ~isnumeric(A)
    error('The argument should be a numeric array!');
elseif ndims(A)~=2
    error('The argument should be an NxN matrix!');
end
    
a = size(A);
if a(1)~=a(2)
    error('The argument should be a square matrix!');
end
E = [];
for i=1:a(1)
    for j=i:a(1)
        if A(i,j)~=0
            E = [E;i,j];
        end
        if A(j,i)~=0
            E = [E;j,i];
        end
    end
end
            