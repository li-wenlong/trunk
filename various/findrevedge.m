function ind = findrevedge( E, e )
% i = findrevedge( E, e ) finds the (row) index of the reverse of e 
% in the set of edges E, i.e., if e = (i,j), it returns the index of 
% (j,i)

ind = findedge( E, [e(2),e(1)]);
