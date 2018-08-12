
% This scripts compares the MAP and MMSE estimates of the number of objects
% in Poisson distributions.
Xs = [0:20];
Lambdas = [1,2,3,4,7,10];

figure
hold on
mymap = linspecer(length( Lambdas ));
for k=1:length( Lambdas )
    
    pmf_  = poisspdf( Xs , Lambdas(k) );
    
    [maxval maxind] = max(pmf_);
    
    if abs( Xs(maxind) - Lambdas(k) )>=1
        disp(sprintf('MAP (%f) differes than MMSE for Lambda %f ', Xs(maxind) , Lambdas(k) ));
    end
      
    col = mymap(k,:);
    plot( Xs, pmf_, 'Color',col)
    drawnow;
end