function col = getcol( r )

col = r.palette( r.counter, : );

r = incCounter(r);
if ~isempty( inputname(1) )
    assignin('caller',inputname(1),r);
end
