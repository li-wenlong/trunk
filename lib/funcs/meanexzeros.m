function m = meanexzeros(A, varargin)



numsteps = size(A,2);

for i=1:numsteps
    numnonzero = length(find(A(:,i)~=0 ) );
    
    m(i) = sum( A(:,i))/numnonzero;
end