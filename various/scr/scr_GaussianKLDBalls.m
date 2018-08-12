% This script is to compare the KLD bound of a Gaussian
ref_mu = 0;
ref_sigmasq = 1;

myeps = 0.01;


mus = [-0.5:0.01:0.5];
sigsqs = [ 1-0.3:0.01:1+0.3];

[Xs,Ys] =  meshgrid(mus, sigsqs);

Zs = zeros( size(Xs) );
Zs2 = Zs;
for i=1:size(Xs,1)
    for j = 1:size(Xs,2)
        Zs(i,j) = gkld( ref_sigmasq, Ys(i,j), ref_mu, Xs(i,j) );
        Zs2(i,j) = gkld( Ys(i,j), ref_sigmasq, Xs(i,j), ref_mu );
    end
end


% Find the Gaussian in the myeps ball
bind = find( Zs(:)< myeps);

if ~isempty( bind )
    xs = [ -3*sqrt(ref_sigmasq):0.001:3*sqrt(ref_sigmasq)]';
    y1 = (1/sqrt(2*pi*ref_sigmasq))*exp(-0.5*(xs - ref_mu).^2/ref_sigmasq);
    
    figure
    subplot(211)
    hold on
    grid on
   
    for j=1:length(bind)
       y2 = (1/sqrt(2*pi*ref_sigmasq))*exp(-0.5*(xs - Xs(bind(j))).^2/Ys(bind(j)) );
   
       l2 = plot(xs,y2,'r');
    end
    
     l1 = plot(xs,y1,'b');
    legend([l1,l2],'reference Normal dist.','KLD ball')
    title(sprintf('KLD Ball of eps = %g',myeps))
    subplot(212)
    hold on 
    grid on
    plot( Xs(:), Ys(:), '.g' )
    plot( Xs(bind(:)), Ys(bind(:)) ,'ob')
    plot( ref_mu, ref_sigmasq ,'xr')
    xlabel('\mu')
    ylabel('\sigma^2')
end



figure
subplot(221)
surfc(Xs,Ys, ( Zs) )
lighting phong
shading flat
xlabel('mu')
ylabel('sigmasq')
zlabel('D(p||q)')



subplot(222)
surfc(Xs,Ys, log( Zs) )
lighting phong
shading flat
xlabel('mu')
ylabel('sigmasq')
zlabel('log kld')


subplot(223)
surfc(Xs,Ys, ( Zs2) )
lighting phong
shading flat
xlabel('mu')
ylabel('sigmasq')
zlabel('D(p,q)+D(q,p)')


subplot(224)
surfc(Xs,Ys, log( Zs2) )
lighting phong
shading flat
xlabel('mu')
ylabel('sigmasq')
zlabel('log D(p,q)+D(q,p)')
