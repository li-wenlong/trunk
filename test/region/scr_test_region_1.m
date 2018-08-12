
r1 = region('circular', [10 -10], 15 );
r2 = region( [ [-20 20]', [-20 10]', [-10 10]', [-10 20]' ] );

nupnts = 2000;


pnts = [30]*[randn(2,nupnts)];

i1 = r1.isin( pnts );
i2 = r2.isin( pnts );

val1 = r1.parint( pnts );
val2 = r2.parint( pnts );

disp(sprintf('int1 = %g, int2 = %g ', val1, val2));


figure
hold on
axis([-40 40 -40 40])
axis equal
grid on
plot( pnts(1,:), pnts(2,:),'b.' )
plot( pnts(1,i1), pnts(2,i1), 'ro' )
plot( pnts(1,i2), pnts(2,i2), 'go' )
legend('points','R_1','R_2')