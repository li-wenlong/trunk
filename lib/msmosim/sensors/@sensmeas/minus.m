function c = plus(a,b)

c = a;
fnames = fieldnames(a);
for i=1:length(fnames)
    for j=1:length(c)    
    
    c(j) = setfield( c(j), fnames{i}, getfield(a(j), fnames{i}) - getfield(b, fnames{i}) );
    end
end