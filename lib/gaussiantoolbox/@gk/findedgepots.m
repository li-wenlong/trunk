function p = findedgepots( p_x, E, varargin )
% p = findedgepots( p_x, E )
% Returns [J_{t,t} J_{s,t}]
%         [J_{t,s} J_{s,s}]
% of the gaussian kernel object p_x where J is the inverse covariance
% matrix for all (t,s) in the list E. The fields of p_x are assumed scalars
% of unity dimensions. If not, then consider the alternative function call:
% p = findedgepots( p_x, E, dims )
% takes into account the dimensionality of the variables stored in the
% array dims.
%
% These potentials should be used in accordance with Eq.s 2.42-2.45 in Erik
% Sudderth's master thesis.

% Murat Uney 20.01.2014

dims = ones(1, size( p_x.C, 1) )';
if nargin>2
    dims = varargin{1}(:);
end

stind = [1; cumsum( dims )+1];
stind = stind(1:end-1);

V = unique( E(:), 'stable' );
for i=1:size( E ,1)
    ind1 = [stind( E(i,1) ):stind( E(i,1) )+dims( E(i,1) ) - 1  ]';
    ind2 = [stind( E(i,2) ):stind( E(i,2) )+dims( E(i,2) ) - 1  ]';
    
    [C_p, mu_p ] = gaussmarg( p_x.C , [ind1(:);ind2(:)], p_x.m );
    p_joint = cpdf( gk( C_p, mu_p ) );
    
    %% Rescale the variances to meet with the consistency condition
    
    %      % The straightforward scaling by equally distributing the variance
    %      % over neighbours does not work always in that it does not necessarily
    %      % lead to a positive definite edge potential covariance (or its
    %      % inverse):
    %      ns1 = nei( E, E(i,1) );
    %      ns2 = nei( E, E(i,2) );
    %      p_joint.S(1,1) = p_joint.S(1,1)/length(ns1);
    %      p_joint.S(2,2) = p_joint.S(2,2)/length(ns2);
    %      C_s = p_joint.S^(-1);
    %      p(i) = gk( C_s, p_joint.m ); % If the rescaling leads to a non-positive definite matrix, that could be caught in the constructor
    
    
    %       % Rescale with p(x_i)p(x_j)
    %       % This does not lead to nicely bell shaped (positive def. matrices
    %       % for) edge potentials either
    %       [C_i, mu_i ] = gaussmarg( p_x.C , E(i,1), p_x.m );
    %       [C_j, mu_j ] = gaussmarg( p_x.C , E(i,2), p_x.m );
    %       p_i = cpdf( gk( C_i, mu_i ) );
    %       p_j = cpdf( gk( C_j, mu_j ) );
    %
    %       C_ij = [ C_i, zeros(size(C_j)); zeros(size(C_j)), C_j];
    %
    %       scalefact = p_i.Z*p_j.Z;
    %
    %       timesmarg = gk( C_ij, [ p_i.m;p_j.m] );
    %       timesmarg.Z = scalefact;
    %
    %       p(i) = p_joint/timesmarg;
    
    %% Go with 2.42, 2.43 in Sudderth thesis and update the local stuff with 2.44 and 2.45
    p(i) = p_joint;
    
    
    dummy = gk;
    dummy.S = [ [p_x.S(ind1,ind1), p_x.S(ind1,ind2)];[p_x.S(ind2,ind1), p_x.S(ind2,ind2) ] ];
    dummy.m = p_x.m([ind1;ind2]);
    
    p(i) = dummy;
end

    
    