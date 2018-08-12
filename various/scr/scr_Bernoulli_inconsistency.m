alphais = [0.1:0.01:1];
alphajs = [0.1:0.01:1];
omegavals = [0:0.01:1];

ts = zeros( length(alphais), length(alphajs), length(omegavals) );
for i=1:length( alphais )
    alphai = alphais( i );
    for j=1:length( alphajs )
        alphaj = alphajs( j );
        for k=1:length( omegavals )
            omegaval = omegavals(k);
            
            denom = ( alphai^(1-omegaval)*alphaj^omegaval )/min(alphai, alphaj)...
                - alphai^(1-omegaval)*alphaj^omegaval;
            
            num = (1-alphai)^(1-omegaval)*(1-alphaj)^(omegaval);
            
            if num == 0 && denom == 0
                tval = 1;
            elseif denom ~= 0
                tval = num/denom;
            else
                error('number/0 undefinite')
            end
            
            ts(i,j,k) = tval;
            
            if tval < 1-eps && omegaval ~=0 && omegaval ~=1
                disp('***********')
               alphai
               alphaj
               omegaval
               tval                
            end
            
        end
    end
end

figure
plot(ts(:))
            
        
        