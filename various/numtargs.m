function numXt = numtargs( Xt )

numXt = [];
for j=1:length(Xt)
    numXt(j) = size(Xt{j},2);
end