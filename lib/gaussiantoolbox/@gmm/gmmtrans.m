function gt = gmmtrans( g )

dimx = getdims(g);
gt.x = getmeans( g.pdfs );
gt.P = zeros( dimx, dimx, length( g.w ) );
gt.w = g.w;
for i=1:length(g.w)
   gt.P(:,:,i) = reshape( get( g.pdfs(i), 'C' ), dimx, dimx, 1 );
end