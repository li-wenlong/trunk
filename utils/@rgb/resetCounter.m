function r = resetCounter(r)

r.counter = 1;
if ~isempty( inputname(1) )
    assignin('caller',inputname(1),r);
end