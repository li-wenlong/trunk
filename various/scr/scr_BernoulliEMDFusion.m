alphais = [0:0.01:1];
alphajs = [0:0.01:1];

[alphaixy , alphajxy ] = meshgrid( alphais, alphajs );  
% Find the min. of 
minalpha = zeros(size(alphaixy)); 
[AA, BB] = find( alphaixy < alphajxy );
minalpha(AA + (BB-1)*size(minalpha,1) ) = alphaixy(AA + (BB-1)*size(alphaixy,1));
[AA, BB] = find( alphaixy >= alphajxy );
minalpha(AA + (BB-1)*size(minalpha,1) ) = alphajxy(AA + (BB-1)*size(alphajxy,1));
%figure
%plot3(alphaixy(:), alphajxy(:), minalpha(:),'.' )


omegas = [0.25:0.25:0.75];
Zvals = [0.5:0.1:1.5];

fhandle = figure;
fhandle2 = figure;
for j=1:length(Zvals)
    for i=1:length( omegas )
           
    ineqmap = zeros(size(alphaixy));    
    omegaval = omegas(i);
    zomega = Zvals(j);
    alp_fus =(alphaixy.^(1-omegaval).*alphajxy.^omegaval*zomega)./...
        ( (1-alphaixy).^(1-omegaval).*(1-alphajxy).^omegaval +...
        alphaixy.^(1-omegaval).*alphajxy.^omegaval*zomega );
    
    [AA,BB] = find( alp_fus<minalpha-eps);
    ineqmap( AA + (BB-1)*size(ineqmap,1)) = 1;
    
    figure(fhandle)
    clf;
    surf(alphaixy, alphajxy, alp_fus )
    
    figure(fhandle2)
    clf;
    surf(alphaixy, alphajxy, alp_fus.*ineqmap )
    
    disp( sprintf('omega = %g , Zomega = %g, Press any key...', omegaval, zomega ) );
    pause
    end
end
    
    
