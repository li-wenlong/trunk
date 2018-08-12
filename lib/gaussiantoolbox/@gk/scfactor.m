function Z = scfactor( gks )
% SCFACTOR; scale factor outputs the scale factor for a series of weighted
% Gaussian components to have their sum integrate to 1.

Z = 0;
for i=1:length(gks)
    Z = Z + iscfactor(gks(i));
end


function  z = iscfactor( gk )

if gk.isScalar == 1
    if gk.sval == 0
        z = 0;
    elseif gk.sval<0
        z = -inf;
    elseif gk.sval>0
        z = inf;
    end
else
    dim = getdims( gk );
    z = gk.Z* ( (2*pi)^(dim/2) )*( det(gk.C)^(1/2) );
end