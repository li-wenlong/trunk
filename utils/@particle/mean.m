 function mv = mean(these)
  % MEAN returns the means of the clusters in the particle array
  
  mv = [];
  if isempty(these)
      return;
  end
  
  
  c1 = these.getlastlabel;
  complabels = unique(c1,'legacy');
  numcomps = length( complabels );
  
  p1 = these.catstates;
  w1 = these.catweights;
  
  myeps = 1.0e-8;
  ndims = size(p1,1);
  j = 1;
  for i=1:numcomps
      ind_ = find( c1 == complabels( i ) );
      mv(:,i) = mean( p1(:, ind_ ) ,2 );
      
  end
  