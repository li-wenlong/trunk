function x = reorder( x, r)
% x = reorder( x, r) changes the order of the fields of the Gaussian
% vectors in gk array x.
% r is a permutation of [1,...,N] for N dimensional vectors.

% Murat Uney


E = eye(N);
E = E( r,:);
for i=1:length( x)
    x_ = x(i);
    x_.m = E*x_.m;
    x_.C = E*x_.C*E';
    x_.S = E*x_.S*E';
    x(i) = x_;
end

    
