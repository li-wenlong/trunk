function c = diag(these)
% This function outputs a single joint distribution given marginal
% distributions under the assumption that they are independent, hence,
% diagonalising their information matrix.

% Murat Uney 15.06.2017 Added col. operator before these is manipulated
% Murat Uney

% Make inputs in column order.
these = these(:);

for i=1:length( these )
    dim_(i) = length(these(i).m  );
end
jdim = sum( dim_ ); % dimensionality of the joint vector
jind = [1, cumsum( dim_ )+1];
jind = jind(1:end-1); % These are the starting indices for the marginal variables

dC = zeros( jdim );
dS = zeros( jdim );
dm = zeros( jdim,1);

dm = cell2mat({these(:).m});
dm = dm(:);
dZ = 1;
for i=1:length(these)
    dZ = dZ*these(i).Z;
    dC( jind(i):jind(i) + dim_(i) -1 , jind(i):jind(i) + dim_(i) -1 ) = these(i).C;
    dS( jind(i):jind(i) + dim_(i) -1, jind(i):jind(i) + dim_(i) -1 ) = these(i).S;
end

c = gk;
c.m = dm;
c.C = dC;
c.S = dS;
c.Z = dZ;