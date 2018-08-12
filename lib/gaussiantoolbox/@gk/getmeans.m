function m = getmeans(gks)

m = zeros( getdims(gks(1)), length(gks) );
for i=1:length(gks)
    m(:, i) = gks(i).m;
end