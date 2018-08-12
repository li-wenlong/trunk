function gmm1 = approxrp( gmm1, alpha_ )

gmm1 = gmm( gmm1.w.^alpha_, gmm1.pdfs.^alpha_ );