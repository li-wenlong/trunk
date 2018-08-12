printFigure2files = 1; % toggle to 1 to print figures

x = [0,0]';


s1 = [0,1]'; % Location of the first sensor
s2 = [2,0]'; % Location of the second sensor

alpha1 = 0.8; % existence probability in the first Bernoulli
alpha2 = 0.8; % existence probability in the second Bernoulli

m1 = x + [0.25, 0.25]';
m2 = x + [-0.75, -0.25]';

oms = [0:0.01:1]';
condnum = [1:0.05:40];

fig1 = figure;
hold on
grid on

fig2 = figure;
hold on
grid on

fig3= figure;
hold on
grid on


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
    
    % For all omegas in oms, find zs
    z = zomegagauss( m1, C1, m2, C2, oms );
    
    denum = ( alpha1.^(1-oms) ).*( alpha2.^oms ).*z + ...
        (( 1- alpha1).^(1-oms) ).*( (1-alpha2).^oms );
    
    alpha_omegas = ( alpha1.^(1-oms) ).*( alpha2.^oms ).*z./denum;
    
    
    
    
    colnum = ceil(numcol*i/numexp);
    col = mymap( colnum ,:);
      
    optstr1 = ['''color'',[', num2str(col) ,'],''linestyle'',''-'''];
    optstr2 = ['''color'',[', num2str(col) ,'],''linestyle'',''-.'''];
    figure( fig1 )
    hold on
    g1.draw('axis',gca,'dims',[1 2]', 'options', optstr1 )
    g2.draw('axis',gca,'dims',[1 2]','options', optstr2 )
    drawnow;
    
    figure( fig2 )
    hold on
    plot( oms, z , 'color', col )
    drawnow;
    
    figure( fig3 )
    hold on
    plot( oms, alpha_omegas , 'color', col )
    drawnow;
    
    
end


% Below figure for z_omega vs. varying condition number and omega
if printFigure2files
    fh = fig2;
    set(fh, 'Color', [1 1 1])
    colormap( mymap );
    cbh = colorbar( 'peer', gca );
    set( cbh, 'Ticks', [1 10 20 30 40],'TickLabels', {'1','10','20', '30', '40'} );
    %  axis equal
    %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
    %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    set(gcf, 'PaperUnits', 'inches')
    myPaperSize = get(gcf, 'PaperSize');
    myWidth = 8.5/2;
    myHeight = myWidth;
    myLeft = ( myPaperSize(1) - myWidth )/2;
    bottom_ = (myPaperSize(2) - myHeight)/2;
    myFigureSize = [myLeft, bottom_, myWidth, myHeight];
    set(gcf, 'PaperSize', [myWidth myHeight])
    set( gcf, 'PaperPositionMode','manual')
    set( gcf, 'PaperPosition', myFigureSize)
    set( gcf, 'renderer', 'painters')
    
    print( gcf, '-depsc2', ['gauss-Berneoulli-zomega','.eps'])
end

 % Below is the alpha_omega vs. varying condition number and omega   
 if printFigure2files
     fh = fig3;
     set(fh, 'Color', [1 1 1])
     colormap( mymap )
     cbh = colorbar( 'peer', gca )
     set( cbh, 'Ticks', [1 10 20 30 40],'TickLabels', {'1','10','20', '30', '40'} );
    
     %  axis equal
     %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
     %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
     set(gcf, 'PaperUnits', 'inches')
     myPaperSize = get(gcf, 'PaperSize');
     myWidth = 8.5/2;
     myHeight = myWidth;
     myLeft = ( myPaperSize(1) - myWidth )/2;
     bottom_ = (myPaperSize(2) - myHeight)/2;
     myFigureSize = [myLeft, bottom_, myWidth, myHeight];
     set(gcf, 'PaperSize', [myWidth myHeight])
     set( gcf, 'PaperPositionMode','manual')
     set( gcf, 'PaperPosition', myFigureSize)
     set( gcf, 'renderer', 'painters')
     
      print( gcf, '-depsc2', ['gauss-Berneoulli-existenceProb','.eps'])
 end


