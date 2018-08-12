function sm = getsalmap2( ld, ad, bd)

% % Downsample l with D
% D = 1;
% 
% ld = l(1:D:end,1:D:end);
% ad = a(1:D:end,1:D:end);
% bd = b(1:D:end,1:D:end);

md = ceil( min( size(ld) ) );

off1 = ceil( md/8);
off2 = ceil( off1/2);
off3 = ceil( off2/2 );

kernel1 = ones(off1*2+1,off1*2+1)/((2*off1+1)^2);
kernel2 = ones(off2*2+1,off2*2+1)/((2*off2+1)^2);
kernel3 = ones(off3*2+1,off3*2+1)/((2*off3+1)^2);

% Find the fft of the kernels by padding zeros to make the output identical
% size for all.
spec_ld = fft2( ld, size(ld,1) + off1*2, size(ld,2) + off1*2  );
spec_ad = fft2( ad, size(ad,1) + off1*2, size(ad,2) + off1*2  );
spec_bd = fft2( bd, size(bd,1) + off1*2, size(bd,2) + off1*2  );

spec_k1 = fft2( kernel1, size(ld,1) + off1*2, size(ld,2) + off1*2  );
spec_k2 = fft2( kernel2, size(ld,1) + off1*2, size(ld,2) + off1*2  );
spec_k3 = fft2( kernel3, size(ld,1) + off1*2, size(ld,2) + off1*2  );



o1_ld = real( ifft2( spec_ld.*spec_k1 ) );
o2_ld = real( ifft2( spec_ld.*spec_k2 ) );
o3_ld = real( ifft2( spec_ld.*spec_k3 ) );

o1_ad = real( ifft2( spec_ad.*spec_k1 ) );
o2_ad = real( ifft2( spec_ad.*spec_k2 ) );
o3_ad = real( ifft2( spec_ad.*spec_k3 ) );

o1_bd = real( ifft2( spec_bd.*spec_k1 ) );
o2_bd = real( ifft2( spec_bd.*spec_k2 ) );
o3_bd = real( ifft2( spec_bd.*spec_k3 ) );

% 
% figure
% subplot(331)
% imagesc(o1_ld)
% subplot(332)
% imagesc(o2_ld)
% subplot(333)
% imagesc(o3_ld)
% 
% subplot(334)
% imagesc(o1_ad)
% subplot(335)
% imagesc(o2_ad)
% subplot(336)
% imagesc(o3_ad)
% 
% subplot(337)
% imagesc(o1_bd)
% subplot(338)
% imagesc(o2_bd)
% subplot(339)
% imagesc(o3_bd)



o1_ld = o1_ld(off1+1:end-off1,off1+1:end-off1);

o2_ld = o2_ld(1:end-2*(off1-off2),1:end-2*(off1-off2) );
o2_ld = o2_ld(off2+1:end-off2, off2+1:end-off2);


o3_ld = o3_ld(1:end-2*(off1-off3), 1:end-2*(off1-off3) );
o3_ld = o3_ld(off3+1:end-off3, off3+1:end-off3);

o1_ad = o1_ad(off1+1:end-off1,off1+1:end-off1);

o2_ad = o2_ad(1:end-2*(off1-off2),1:end-2*(off1-off2) );
o2_ad = o2_ad(off2+1:end-off2, off2+1:end-off2);

o3_ad = o3_ad(1:end-2*(off1-off3), 1:end-2*(off1-off3) );
o3_ad = o3_ad(off3+1:end-off3, off3+1:end-off3);

o1_bd = o1_bd(off1+1:end-off1,off1+1:end-off1);

o2_bd = o2_bd(1:end-2*(off1-off2),1:end-2*(off1-off2) );
o2_bd = o2_bd(off2+1:end-off2, off2+1:end-off2);


o3_bd = o3_bd(1:end-2*(off1-off3), 1:end-2*(off1-off3) );
o3_bd = o3_bd(off3+1:end-off3, off3+1:end-off3);

cv1 = (ld-o1_ld).^2 + (ad - o1_ad).^2 + (bd - o1_bd).^2;
cv2 = (ld-o2_ld).^2 + (ad - o2_ad).^2 + (bd - o2_bd).^2;
cv3 = (ld-o3_ld).^2 + (ad - o3_ad).^2 + (bd - o3_bd).^2;


sm = cv1 + cv2 + cv3;