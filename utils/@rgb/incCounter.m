function r = incCounter(r)

numColors = size(r.palette , 1);
r.counter = r.counter+1;
if r.counter> numColors
    r.counter = 1;
end