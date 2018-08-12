function o = getpersistent( i )

ind = find( i.ispersistent == 1);
o = i.getel(ind);