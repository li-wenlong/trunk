
numbins = 9;

mu1 = 5;
var1 = 2;
mu2 = 5;
var2 = 2;

zomegavals = [0.1:0.005:0.9];
omegavals = [0:0.01:1];

ns = [0:numbins]';
card1 = binopdf( [0:numbins], mu1, 0.95 )';
card2 = binopdf( [0:numbins], mu2, 0.9 )';
%card1 = poisspdf( [0:numbins], mu1 +0.25 )';
% card2 = poisspdf( [0:numbins], mu2 + 0.1 )';
%card1 = nbinpdf( [0:numbins], mu1 +0.25 )';
%card2 = nbinpdf( [0:numbins], mu2 +0.1 )';
%card1 = [card1(1:mu1+1); flipud(card1(1:mu1))];

%card2 = [card2(1:mu2+1); flipud(card2(1:mu2))];


card1 = card1(1:length(ns));
card1 = card1/sum(card1);

card2 = card2(1:length(ns));
card2 = card2/sum(card2);


minseries = min( card1, card2 );


mymap = linspecer;
numcol = size( mymap, 1 );
numexp = length( zomegavals );



fig1 = figure;
set(fig1, 'Color', [1 1 1])
hold on
grid on



fig2 = figure;
set(fig2, 'Color', [1 1 1])
hold on
grid on



% First, plot some intermediate examples
% i.e., fusion results
fig4 = figure;
set(fig4, 'Color', [1 1 1])
hold on
grid on

plotexamples = [1, fix( [1/5 2/5 3/5 4/5]*numexp ), numexp];
for i=1:length( plotexamples)
    omegaval = 0.5;
     zomega = zomegavals(plotexamples(i));
     zomegan = ( zomega.^ns );
     
     colnum = ceil(numcol*plotexamples(i)/numexp);
     col = mymap( colnum ,:);
     
     fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
     Nomega = sum(fusedcard);
     fusedcard =  fusedcard/Nomega;
     
     figure( fig4 )
     hold on
     plot( ns, fusedcard, '--','Color', col,'Linewidth',1.5 )
end

legendstr = {};
for i=1:length( plotexamples )
    legendstr{i} = num2str( zomegavals( plotexamples(i)) );
end
legend( legendstr );

plot( ns, card1, 'b', 'linewidth', 2 )
plot( ns, card2, 'g', 'linewidth', 2 )  
axis([0 max(ns) 0 1])
set( gca, 'XtickMode', 'auto' )
set( gca, 'FontSize', 16 )
ylabel('n')




for i=1:numexp

    colnum = ceil(numcol*i/numexp);
    col = mymap( colnum ,:);
    
    zomega = zomegavals(i);
    
    zomegan = ( zomega.^ns );
    
    incbound = [];
    for j=1:length( omegavals )
        
        omegaval = omegavals( j );
        expseries = ( card1.^(1-omegaval) ).*( card2.^omegaval );
        
        bndratio = minseries./expseries;
        bndratio( isnan( bndratio ) ) = 1;

        gamma_ = min ( bndratio );
        
        fusedcard = ( card1.^(1-omegaval) ).*( card2.^omegaval ).*zomegan;
        Nomega = sum(fusedcard);
        fusedcard =  fusedcard/Nomega;
        
        [mval, mind] = max(fusedcard);
        mapvals(i,j) = ns(mind); 
        
        if ( omegaval - 0.5 )< abs( omegavals(min(j+1, length( omegavals ) ))-omegavals(max(j-1,1 )) )/2

            incbound = ( Nomega*bndratio ).^(1./ns) ;% Inconsistency bound
        end
        
        ntilde = log(  Nomega*gamma_)/log( zomega );
        ntildes(i,j) = ntilde;
        
        figure( fig4 )
        hold on
        plot( ns, fusedcard, ':','Color', col )
        
    end

      
    optstr1 = ['''color'',[', num2str(col) ,'],''linestyle'',''-'''];
    optstr2 = ['''color'',[', num2str(col) ,'],''linestyle'',''-.'''];
    figure( fig1 )
    hold on
    plot( omegavals ,  ntildes(i,:),  'color', col )
    
    figure( fig2 )
    hold on
    plot( ns ,incbound, 'color', col )
    
 
    drawnow;
end
drawnow;


fh = fig2;
figure( fh )
set(fh, 'Color', [1 1 1])
axis([0 max(ns) 0 1])
colormap( mymap );
cbh = colorbar( 'peer', gca );
set( cbh, 'Ticks', [ zomegavals(fix(numexp/6)) zomegavals(fix(3*numexp/6)) zomegavals(fix(5*numexp/6)) ],...
    'TickLabels', {num2str( zomegavals(fix(numexp/6)) ), num2str( zomegavals(fix(3*numexp/6)) ) , num2str( zomegavals(fix(5*numexp/6)) ) } );

[xx,yy] = meshgrid(omegavals, zomegavals );
fig3 = figure;
set( fig3, 'Color', [1 1 1] );
surf(xx,yy, mapvals  )
shading flat
view(0,90)




