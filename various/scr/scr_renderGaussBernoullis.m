printFigure2files = 1;
x = [0,0]';


s1 = [0,1]'; % Location of the first sensor
s2 = [2,0]'; % Location of the second sensor

alpha1 = 0.8; % existence probability in the first Bernoulli
alpha2 = 0.8; % existence probability in the second Bernoulli

m1 = x + [0.25, 0.25]';
m2 = x + [-0.75, -0.25]';

oms = [0:0.01:1]';
condnum = [1,10,20,30,40];

fig1 = figure;
hold on
grid on
axis([-3 3 -3 3]);
efaxis = gca;
set( fig1, 'color', [1 1 1] );
set( efaxis, 'XtickMode', 'auto' )
set( efaxis, 'FontSize', 14 )

mymap = linspecer;
numcol = size( mymap, 1 );
numexp = length( condnum );


opt_omegas = zeros(numexp, 1);
z_optomegas = zeros(numexp, 1);

for i=1:numexp
    
    % Get the condition number that specifies this experiment
    K = condnum( i );
    
    % Find the variances (i.e., eigen values of the covariances)
    var1 = K/(K+1);
    var2 = 1-var1;
    
    
    % rotation 1
    R1 = rotmat2d(pi/4);
    % covariance 1
    C1 = R1*[var1 0;0 var2]*R1';
    
    var1b = var1;
    var2b = var2;
    
    % rotation 2
    R2 = rotmat2d(-pi/4);
    % covariance 2
    C2 = R2*[var1b 0;0 var2b]*R2';
    
    % Create gk objects
    g1 = gk( C1, m1 );
    g1 = g1.cpdf;
    g2 = gk( C2, m2 );
    g2 = g2.cpdf;
     
    
    colnum = ceil(numcol*i/numexp);
    %col = mymap( colnum ,:);
    col = [0 0 0];
      
    optstr1 = ['''color'',[', num2str(col) ,'],''linestyle'',''-'''];
    optstr2 = ['''color'',[', num2str(col) ,'],''linestyle'',''-.'''];
    figure( fig1 )
    clf;
    grid on
    hold on
    g1.draw('axis',gca,'dims',[1 2]', 'options', optstr1 )
    g2.draw('axis',gca,'dims',[1 2]','options', optstr2 )
    drawnow;
    
    
    if printFigure2files
        fh = gcf;
        set(fh, 'Color', [1 1 1])
        
        %  axis equal
        %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
        %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
        set(gcf, 'PaperUnits', 'inches')
        myPaperSize = get(gcf, 'PaperSize');
        myWidth = 8.5/5;
        myHeight = myWidth;
        myLeft = ( myPaperSize(1) - myWidth )/2;
        bottom_ = (myPaperSize(2) - myHeight)/2;
        myFigureSize = [myLeft, bottom_, myWidth, myHeight];
        set(gcf, 'PaperSize', [myWidth myHeight])
        set( gcf, 'PaperPositionMode','manual')
        set( gcf, 'PaperPosition', myFigureSize)
        set( gcf, 'renderer', 'painters')
        
         print( gcf, '-depsc2', ['gauss', num2str(i) ,'.eps'])
    end
    
    
    
end



