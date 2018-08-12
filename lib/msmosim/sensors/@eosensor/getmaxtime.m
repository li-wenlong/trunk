function maxtime = getmaxtime( these )

tarr = cell2mat({these.time});
maxtime = max( tarr );