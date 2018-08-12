  function g_ = par2gmm(these)
  % Find the corresponding gmm and return it back
  % first, find the cluster names
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
      mean_ = mean( p1(:, ind_ ) ,2 );
      
      if size( p1, 2) == 1
          cov_ = myeps*eye(ndims);
      else
          cov_ = cov( p1(:, ind_ )' );
      end
      % Condition cov_
      [V,D] = eig( cov_ );
      
      svals = diag(D);
      svals( find( svals < myeps ) ) = myeps;
      
      ccov_ = V*diag(svals)*V';
      pccov_ = (ccov_ + ccov_')/2;
      
      
      gks(j) = cpdf( gk(pccov_, mean_ ) );
      weights_(j) = sum(w1(ind_));
      j=j+1;
  end
  g_ = gmm( weights_, gks );
  