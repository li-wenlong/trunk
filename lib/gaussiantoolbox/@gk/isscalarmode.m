function l = isscalarmode(gks)

l = zeros(size(gks));
for i=1:length(gks(:))
    l(i) = gks(i).Z>=1;
end
