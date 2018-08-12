function E = selmatrix( p_ind, varargin )

if nargin >=2
    q_ind = varargin{1};
else
    q_ind = [1:p_ind];
end

lenP = length( p_ind );
lenQ = length( q_ind );

E = zeros( lenP, lenQ );
for i=1:lenP
    


E = eye(N);
E = E( [p_ind;q_ind],:);


