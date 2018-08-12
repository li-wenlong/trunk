
% Load particles p
% p has one label = 0
% It is possible to cluster these using the history length
load parfile#2.mat

pdfcfg_ = pdfcfg;
pdfcfg_.particles = marginal( p, [1,2]);
pdf_ = pdf( pdfcfg_);




parts = p.states([1 2],:);


zparts_gmm = pdf_.evaluate( parts, 'gmm' );
zparts_kde = pdf_.evaluate( parts, 'kde' );

figure
hold on
grid on
plot3( parts(1,:), parts(2,:), zparts_gmm,'.' )
plot3( parts(1,:), parts(2,:), zparts_kde, '.r' )
legend('gmm','kde')
