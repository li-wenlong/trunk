function r = decCounter(r)

numColors = size(r.palette , 1);
r.counter = r.counter-1;
if r.counter < 1 
    r.counter = numColors;
end