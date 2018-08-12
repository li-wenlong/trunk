function d = ospahell( gmm1, gmm2 )



g1 = gmmtrans( gmm1 );
g2 = gmmtrans( gmm2 );

% Combined, localisation and cardinality 
[td, d, cd] = ScaledDistance( g1.x, g1.P, g2.x, g2.P, 100, 1, 0);
