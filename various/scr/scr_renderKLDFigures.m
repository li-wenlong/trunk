% This script is to render figures of KLDs and I bounds
printFigure2files = 1;
% First, open up scr_AR1MarkovChain_paramestquadterm_numeric.m and run it
edit  scr_AR1MarkovChain_paramestquadterm_numeric.m;
%% Below is the bit for rendering figures
scr_AR1MarkovChain_paramestquadterm_numeric;


fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
plot(d_quad)
plot(quad_i_bound_condkld,'--r')
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
legend('D(p||q)','I bound')
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
    
    print( gcf, '-dpng', ['kld_p2q','.png'])
    print( gcf, '-depsc2', ['kld_p2q','.eps'])
end



fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
plot(d_quad)
plot(quad_i_bound_condkld,'--r')
plot(quad_h_bound,'--m')
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
legend('D(p||q)','I bound','H bound')
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
    
    print( gcf, '-dpng', ['kld_p2q_2','.png'])
    print( gcf, '-depsc2', ['kld_p2q_2','.eps'])
end

%% Below is for the dual term
edit  scr_AR1MarkovChain_paramestdualterm_numeric.m;
%% Below is the bit for rendering figures
scr_AR1MarkovChain_paramestdualterm_numeric



fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
plot(d_dual,'g')
plot(d_quad,'b')
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
legend('D(p||s)','D(p||q)')
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
    
    print( gcf, '-dpng', ['kld_p2s','.png'])
    print( gcf, '-depsc2', ['kld_p2s','.eps'])
end



fhandle = figure;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize',16 );
hold on
grid on
plot(d_dual)
plot(dual_h_bound,'--m')
ylabel('(nats)','FontSize',16)
xlabel('k','FontSize',16)
legend('D(p||s)','H bound')
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
    
    print( gcf, '-dpng', ['kld_p2s_2','.png'])
    print( gcf, '-depsc2', ['kld_p2s_2','.eps'])
end


