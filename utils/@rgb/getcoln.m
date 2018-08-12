function col = getcoln(r, num)


col = r.palette( mod( num -1, size(r.palette,1 ))+1, : );