function np = getnumnodes( ingraphs )

np = zeros( length( ingraphs ) );
for i=1:length( ingraphs )
np(i) = ingraphs(i).N;
end
