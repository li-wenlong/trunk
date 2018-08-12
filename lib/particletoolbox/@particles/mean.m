 function mv = mean(these)
  % MEAN returns the weighted mean of the particle array
  
  mv = [];
  if isempty(these)
      return;
  end
  
  
  p1 = these.getstates;
  w1 = these.getweights;
  w1 = w1/sum(w1);
  
  mv = sum( p1.*( repmat(w1(:), 1, size(p1,1) )' ) , 2);
  