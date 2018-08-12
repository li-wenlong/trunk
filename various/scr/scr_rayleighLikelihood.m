ray_param = 0.1;



lens = [5000:100:20000];
fhandle = figure;
hold on
fhandle2 = figure;
hold on
for cnt=1:length(lens)
    
    Xs = raylrnd( sqrt( ray_param ) , 1, lens(cnt));
    paramest = sum(Xs.^2)/lens(cnt)/2;
    figure(fhandle)
    plot( cnt, paramest ,'ob' )
    plot( cnt, ray_param, 'xr' )
    
    figure(fhandle2)
    plot( cnt, sum(Xs.^2 - 2*ray_param )/(4*ray_param) ,'x' )
    plot( cnt, ( paramest - ray_param )*lens(cnt)/(2*ray_param),'or' )
end