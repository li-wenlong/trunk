function zs = getzs( gks ) 

zs = zeros(size(gks));

for i=1:length(gks)
    zs(i) = gks(i).Z;
end
