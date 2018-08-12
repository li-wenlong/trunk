function d = kld( gmm1, gmm2 )

g1 = gmmtrans( gmm1 );
g2 = gmmtrans( gmm2 );

d = gmm_distance_KLD( g1, g2 );