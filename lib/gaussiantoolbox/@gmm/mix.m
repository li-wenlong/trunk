function ogmm = mix(igmms)

igmms = igmms(:);
numigmms = length(igmms);

opdf = igmms(1).pdfs;
ows = igmms(1).w;

for i=2:length(igmms)
    opdf = [opdf;igmms(i).pdfs ];
    ows = [ows; igmms(i).w ];
end
ogmm = gmm( ows, opdf );