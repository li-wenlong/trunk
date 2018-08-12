function col = getcrrntcol( r )

col = r.palette( r.counter, : );

if ~isempty( inputname(1) )
    assignin('caller',inputname(1),r);
end
