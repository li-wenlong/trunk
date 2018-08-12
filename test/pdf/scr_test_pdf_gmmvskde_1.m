
% Load particles p1 and p2
% p2 has three particles of label 0 and 1,2,3,4
% p1 has no particles of label 0 and 1,2,3,4,8
load parfile#1.mat

% 
pdfcfg1 = pdfcfg;
pdfcfg1.particles = marginal( p1, [1,2]);

pdf1 = pdf( pdfcfg1);

pdfcfg2 = pdfcfg;
pdfcfg2.particles = marginal(p2 , [1,2] );

pdf2 = pdf( pdfcfg2 );

pdfcfg2b = pdfcfg;
pdfcfg2b.particles =  pdfcfg2.particles.getel( find( pdfcfg2.particles.getlabels ~= 0) );

pdf2b = pdf( pdfcfg2b );

%[X,Y] = meshgrid([[-850:1:-450] ],[[1600:1:2000]]);

[X1,Y1] = meshgrid( [-1200:1:-750] , [2420:1:2620] );
xs1 = [X1(:),Y1(:)];

[X2,Y2] = meshgrid( [-850:1:-450], [1600:1:2000] );
xs2 = [X2(:),Y2(:)];

[X3,Y3] = meshgrid( [1350:1:1750], [-1850:1:-1250] );
xs3 = [X3(:),Y3(:)];



% For the first density:
% This is the GMM approximation
s1_gmm_1 = pdf1.evaluate( xs1' ,'gmm');
s1_gmm_2 = pdf1.evaluate( xs2' ,'gmm');
s1_gmm_3 = pdf1.evaluate( xs3' ,'gmm');

% This is the kde approximation
s1_kde_1 = pdf1.evaluate( xs1' ,'kde');
s1_kde_2 = pdf1.evaluate( xs2' ,'kde');
s1_kde_3 = pdf1.evaluate( xs3' ,'kde');

figure
grid on
hold on
mesh(X1,Y1,reshape(s1_gmm_1, size(X1,1), size(X1,2)))
mesh(X2,Y2,reshape(s1_gmm_2, size(X2,1), size(X2,2)))
mesh(X3,Y3,reshape(s1_gmm_3, size(X3,1), size(X3,2)))
xlabel('x')
ylabel('y')
colorbar

figure
grid on
hold on
mesh(X1,Y1,reshape(s1_kde_1, size(X1,1), size(X1,2)))
mesh(X2,Y2,reshape(s1_kde_2, size(X2,1), size(X2,2)))
mesh(X3,Y3,reshape(s1_kde_3, size(X3,1), size(X3,2)))
xlabel('x')
ylabel('y')
colorbar

% Contour plot of target regions; gmm evaluation vs. kde eval.

cmax = max( [max(s1_gmm_1), max(s1_gmm_2), max(s1_gmm_3), ...
    max(s1_kde_1), max(s1_kde_2), max(s1_kde_3)   ] );
figure
subplot(321)
caxis([0 cmax])
grid on
hold on
contour(X1,Y1,reshape(s1_gmm_1, size(X1,1), size(X1,2)))
colorbar

subplot(323)
caxis([0 cmax])
grid on
hold on
contour(X2,Y2,reshape(s1_gmm_2, size(X2,1), size(X2,2)))
colorbar

subplot(325)
caxis([0 cmax])
grid on
hold on
contour(X3,Y3,reshape(s1_gmm_3, size(X3,1), size(X3,2)))
colorbar

subplot(322)
caxis([0 cmax])
grid on
hold on
contour(X1,Y1,reshape(s1_kde_1, size(X1,1), size(X1,2)))
colorbar

subplot(324)
caxis([0 cmax])
grid on
hold on
contour(X2,Y2,reshape(s1_kde_2, size(X2,1), size(X2,2)))
colorbar

subplot(326)
caxis([0 cmax])
grid on
hold on
contour(X3,Y3,reshape(s1_kde_3, size(X3,1), size(X3,2)))
colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% For the second density:
% This is the GMM approximation
s2_gmm_1 = pdf2b.evaluate( xs1' ,'gmm');
s2_gmm_2 = pdf2b.evaluate( xs2' ,'gmm');
s2_gmm_3 = pdf2b.evaluate( xs3' ,'gmm');

% This is the kde approximation
s2_kde_1 = pdf2b.evaluate( xs1' ,'kde');
s2_kde_2 = pdf2b.evaluate( xs2' ,'kde');
s2_kde_3 = pdf2b.evaluate( xs3' ,'kde');


figure
hold on
grid on
mesh( X1,Y1,reshape(s2_gmm_1, size(X1,1), size(X1,2)))
mesh( X2,Y2,reshape(s2_gmm_2, size(X2,1), size(X2,2)))
mesh( X3,Y3,reshape(s2_gmm_3, size(X3,1), size(X3,2)))
xlabel('x')
ylabel('y')
colorbar

figure
hold on
grid on
mesh( X1,Y1,reshape(s2_kde_1, size(X1,1), size(X1,2)))
mesh( X2,Y2,reshape(s2_kde_2, size(X2,1), size(X2,2)))
mesh( X3,Y3,reshape(s2_kde_3, size(X3,1), size(X3,2)))
xlabel('x')
ylabel('y')
colorbar

% Contour plot of target regions; gmm evaluation vs. kde eval.

cmax = max( [max(s2_gmm_1), max(s2_gmm_2), max(s2_gmm_3), ...
    max(s2_kde_1), max(s2_kde_2), max(s2_kde_3)   ] );
figure
subplot(321)
caxis([0 cmax])
grid on
hold on
contour(X1,Y1,reshape(s2_gmm_1, size(X1,1), size(X1,2)))
colorbar

subplot(323)
caxis([0 cmax])
grid on
hold on
contour(X2,Y2,reshape(s2_gmm_2, size(X2,1), size(X2,2)))
colorbar

subplot(325)
caxis([0 cmax])
grid on
hold on
contour(X3,Y3,reshape(s2_gmm_3, size(X3,1), size(X3,2)))
colorbar

subplot(322)
caxis([0 cmax])
grid on
hold on
contour(X1,Y1,reshape(s2_kde_1, size(X1,1), size(X1,2)))
colorbar

subplot(324)
caxis([0 cmax])
grid on
hold on
contour(X2,Y2,reshape(s2_kde_2, size(X2,1), size(X2,2)))
colorbar

subplot(326)
caxis([0 cmax])
grid on
hold on
contour(X3,Y3,reshape(s2_kde_3, size(X3,1), size(X3,2)))
colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

