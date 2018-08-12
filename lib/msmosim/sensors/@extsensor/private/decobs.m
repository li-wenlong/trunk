function do = decobs( myobs, N)

 [obsangs, obsrads ] = cart2pol( myobs(1,:), myobs(2,:) );
 obsangs = mapang(obsangs);
 
 [sangles, sindx ] = sort(obsangs, 'ascend' );
 
 % Take the max and min
 do(:,1) = myobs(:, sindx(1) );
 do(:,2) = myobs(:, sindx(end) );
 
 ssize = floor( (length(sindx))/(N-2) );
 
 otherind = [1+ssize:ssize:length(sindx)-1];
 do(:,3:3+ length(otherind)-1 ) = myobs(:, sindx(otherind));
 
 