% Varying sig_v 


printFigure2files = 1;


sig_ns = sqrt( [0.3:-0.001/4:0.1*2] );
mu_n = 0;

sig_x1s =  sqrt( ( [0.5:-0.001:0.1].^2 )*( (1/(1-0.5^2)) ) );
mu_x1 = 0;

a = 0.5;

sig_vs = sqrt( [0.5:-0.001:0.1] );
mu_v = 0;

sig_theta = 5;
mu_theta = 0;

t = 20; % This is th

numexps = length(sig_vs);
h_bounds = zeros( numexps, t );
i_bounds = zeros( numexps, t );
d_quads = zeros( numexps, t );
for ecnt = 1:numexps

    sig_v = sig_vs(ecnt);
    sig_x1 = sig_x1s( ecnt );
    sig_n = sig_ns( ecnt );
    
    sig_ni = sig_n;
    sig_nj = sig_n;
     mu_ni = mu_n;
     mu_nj = mu_n;

[s_post, mu_post, d_quad, quad_i_bound_condkld, quad_h_bound ] = fun_AR1MarkovChain_paramestquadterm( sig_ni, mu_ni , sig_nj , mu_nj, ...
    sig_x1, mu_x1, a, sig_v, mu_v, sig_theta , mu_theta, t );

h_bounds( ecnt, : )   = quad_h_bound;
d_quads( ecnt, : ) = d_quad;
i_bounds(ecnt, : ) = quad_i_bound_condkld;
end



fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
mymap = ( colormap );
numapels = size( mymap, 1);
for ecnt = 1:numexps
    elnum = round( numapels*(sig_vs(ecnt) - min(sig_vs))/( max(sig_vs) - min(sig_vs))  );
    elnum = max( min( elnum, numapels ), 1);
    col = mymap( elnum ,:);
    plot(h_bounds(ecnt,:),'Color', col )
end
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
colorbar
caxis([ min(sig_vs), max(sig_vs)])
if printFigure2files
    fh = gcf;
    set(fh, 'Color', [1 1 1])
   
  %  axis equal
  %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
  %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    set(gcf, 'PaperUnits', 'inches')
    myPaperSize = get(gcf, 'PaperSize');
    myWidth = 10;
    myHeight = 3.5;
    myLeft = ( myPaperSize(1) - myWidth )/2;
    bottom_ = (myPaperSize(2) - myHeight)/2;
    myFigureSize = [myLeft, bottom_, myWidth, myHeight];
    set(gcf, 'PaperSize', [myWidth myHeight])
    set( gcf, 'PaperPositionMode','manual')
   set( gcf, 'PaperPosition', myFigureSize)
    set( gcf, 'renderer', 'painters')
    
    print( gcf, '-dpng', ['quad_hbounds3','.png'])
    print( gcf, '-depsc2', ['quad_hbounds3','.eps'])
end

%% I bounds


fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
mymap = ( colormap );
numapels = size( mymap, 1);
for ecnt = 1:numexps
    elnum = round( numapels*(sig_vs(ecnt) - min(sig_vs))/( max(sig_vs) - min(sig_vs))  );
    elnum = max( min( elnum, numapels ), 1);
    col = mymap( elnum ,:);
    plot(i_bounds(ecnt,:),'Color', col )
end
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
colorbar
caxis([ min(sig_vs), max(sig_vs)])
if printFigure2files
    fh = gcf;
    set(fh, 'Color', [1 1 1])
   
  %  axis equal
  %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
  %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    set(gcf, 'PaperUnits', 'inches')
    myPaperSize = get(gcf, 'PaperSize');
    myWidth = 10;
    myHeight = 3.5;
    myLeft = ( myPaperSize(1) - myWidth )/2;
    bottom_ = (myPaperSize(2) - myHeight)/2;
    myFigureSize = [myLeft, bottom_, myWidth, myHeight];
    set(gcf, 'PaperSize', [myWidth myHeight])
    set( gcf, 'PaperPositionMode','manual')
   set( gcf, 'PaperPosition', myFigureSize)
    set( gcf, 'renderer', 'painters')
    
    print( gcf, '-dpng', ['quad_ibounds3','.png'])
    print( gcf, '-depsc2', ['quad_ibounds3','.eps'])
end

%% KLD


fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
mymap = ( colormap );
numapels = size( mymap, 1);
for ecnt = 1:numexps
    elnum = round( numapels*(sig_vs(ecnt) - min(sig_vs))/( max(sig_vs) - min(sig_vs))  );
    elnum = max( min( elnum, numapels ), 1);
    col = mymap( elnum ,:);
    
    plot(d_quads(ecnt, :),'Color', col)
end
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
colorbar
caxis([ min(sig_vs), max(sig_vs)])
if printFigure2files
    fh = gcf;
    set(fh, 'Color', [1 1 1])
   
  %  axis equal
  %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
  %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    set(gcf, 'PaperUnits', 'inches')
    myPaperSize = get(gcf, 'PaperSize');
    myWidth = 10;
    myHeight = 3.5;
    myLeft = ( myPaperSize(1) - myWidth )/2;
    bottom_ = (myPaperSize(2) - myHeight)/2;
    myFigureSize = [myLeft, bottom_, myWidth, myHeight];
    set(gcf, 'PaperSize', [myWidth myHeight])
    set( gcf, 'PaperPositionMode','manual')
   set( gcf, 'PaperPosition', myFigureSize)
    set( gcf, 'renderer', 'painters')
    
    print( gcf, '-dpng', ['d_quads3','.png'])
    print( gcf, '-depsc2', ['d_quads3','.eps'])
end


