%---------------------------------------------------------
% Copyright (c) 2010 Radhakrishna Achanta [EPFL]
% Contact: firstname.lastname@epfl.ch
%---------------------------------------------------------
% Citation:
% @InProceedings{Achanta_Saliency_ICVS_2008,
%    author      = {Achanta, Radhakrishna and Extrada, Francisco and S�sstrunk, Sabine},
%    booktitle   = {{I}nternational {C}onference on {C}omputer
%                  {V}ision {S}ystems},
%    year        = 2008
% }
%---------------------------------------------------------
%
%
%---------------------------------------------------------
% Read image
%---------------------------------------------------------
img = imread('2011_Oct_12_15_09_20_296875_im1.jpg');%Provide input image path
dim = size(img);
width = dim(2);height = dim(1);
md = min(width, height);%minimum dimension
%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------
% cform = makecform('srgb2lab', 'whitepoint', whitepoint('d65'));
% lab = applycform(img,cform);
% l = double(lab(:,:,1));
% a = double(lab(:,:,2));
% b = double(lab(:,:,3));
%If you have your own RGB2Lab function...
[l a b] = RGB2Lab(img(:,:,1),img(:,:,2), img(:,:,3));

%  b = 0*ones(256,256);
%  l = zeros(256,256);
%  a = zeros(256,256);
% 
%  l(128,128) = 1;
%---------------------------------------------------------
%Saliency map computation
%---------------------------------------------------------

% Downsample l,a,b
D = 4;
ld = l(1:D:end,1:D:end);ad = a(1:D:end,1:D:end); bd = b(1:D:end,1:D:end);

disp('Using c-mex:')
tic
smd = getsalmap( ld,ad,bd );
toc

disp('Using FFT2:')

tic
smd2 = getsalmap2( ld,ad,bd);
toc

err = smd - smd2;

md = ceil(min(size(ld))/8);

[xx,yy] = meshgrid( [1:size(ld,1)], [1:size(ld,2)] );

figure;
subplot(334)
mesh( xx', yy', smd )
subplot(335)
mesh( xx', yy', smd2 )
subplot(336)
mesh(xx(md+1:end-md-1,md+1:end-md-1)', yy(md+1:end-md-1,md+1:end-md-1)',err(md+1:end-md-1,md+1:end-md-1))

sm = zeros(size(l));
for i=1:D
    for j=1:D
    sm(i:D:end,j:D:end) = smd;
    end
end

figure
[XX,YY]=meshgrid([1:size(l,1)],[1:size(l,2)]);
 mesh(XX',YY',sm)
 
 % Condition the Saliency map
 m = find(sm < mean(mean(sm)));
 smm = sm;
 smm(m) = min(min(sm));
 smm([1:md,end-md+1:md],:) = min(min(sm));
 smm(:,[1:md,end-md+1:md]) = min(min(sm));
 
mykernel =  [0.0694834512228015 0.22313016014843 0.513417119032592 0.846481724890614  1 0.846481724890614 0.513417119032592 0.22313016014843 0.0694834512228015]'...
    *[0.0694834512228015 0.22313016014843 0.513417119032592 0.846481724890614  1 0.846481724890614 0.513417119032592 0.22313016014843 0.0694834512228015];
[M,N] = size(smm);
[K,L] = size(mykernel);

smm = real( ifft2( fft2( smm, M + K-1, N + L - 1 ).*fft2( mykernel, M + K-1, N + L - 1 ) ) );
smm  = smm( (K-1)/2+1:end-(K-1)/2, (K-1)/2+1:end-(K-1)/2 );
 figure
 mesh(XX',YY',smm)
  
 m = find( smm> mean(mean(smm)) );
 reg_maxdist = mean( mean( smm(m) ));
 
 %[mu,mask]=kmeans(255*sm/max(max(sm)),1);
 %[mu,mask]=kmeans(smm,5);
 % figure
 %imagesc(mask)
 %colorbar
 
 [maxvals, maxrows] = max( smm );
 [maxval, seed_col ] = max( maxvals );
 seed_row = maxrows(seed_col);
 
 


 J=regiongrowing(smm,seed_row,seed_col,reg_maxdist);
%---------------------------------------------------------
figure

imagesc(J.*l)
