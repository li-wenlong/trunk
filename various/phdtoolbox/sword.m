function D = sword( C, O )
% SWORD switches the order of rows and columns of a square matrix in
% accordance with the give order and outputs D such that
% D = E*C*E' where E is a row switching transformation
% Y = CX => Y(ord) = DX(ord)
% D = sword(C, O) where O is a permutation of [1:N] and C is a NxN matrix
% returns D = E*C*E'.
%
% See also GGM, GAUSSCOND, GAUSSMARG

% Murat Uney

if nargin<2
    error('Not enough input arguments!');
end
if nargin >=3
    error('Too many input arguments!');
end
if nargin==2
    if ~isnumeric(C)|~isnumeric(O)
        error('Both arguments should be of type numeric!');
    end
    O = O(:);
    if ndims(C) ~=2 | ndims(O)~= 2
        error('The first argument should be an NxN square matrix and the second an array of size N!');
    end
    [N, M] = size(C);
    if length(O) ~= N
        error('O should be of length N for an NxN square matrix!');
    end
    if ~isempty( find( O<1 | O>N ) )
        error('O should be a permutation of [1:N] for an NxN square matrix!');
    end
end
E = eye(N);
E = E(O,:);
D = E*C*E';
    
        