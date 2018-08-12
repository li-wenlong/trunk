%---------------------------------------------------------
% Copyright (c) 2009 Radhakrishna Achanta [EPFL]
% Contact: firstname.lastname@epfl.ch
%---------------------------------------------------------
% Citation:
% @InProceedings{LCAV-CONF-2009-012,
%    author      = {Achanta, Radhakrishna and Hemami, Sheila and Estrada,
%                  Francisco and S�sstrunk, Sabine},
%    booktitle   = {{IEEE} {I}nternational {C}onference on {C}omputer
%                  {V}ision and {P}attern {R}ecognition},
%    year        = 2009
% }
%---------------------------------------------------------
% Please note that the saliency maps generated using this
% code may be slightly different from those of the paper.
% This seems to be because the RGB to Lab conversion is
% different from the one used for the results in the C++ code.
% The C++ code is available on the same page as this matlab
% code (http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html)
% One should preferably use the C++ as reference and use
% this matlab implementation mostly as proof of concept
% demo code.
%---------------------------------------------------------
%
%
%---------------------------------------------------------
% Read image and blur it with a 3x3 or 5x5 Gaussian filter
%---------------------------------------------------------
img = imread('2011_Oct_12_15_09_20_296875_im1.jpg');%Provide input image path



mykernel =  [ 0.846481724890614  1  0.846481724890614]'*[ 0.846481724890614  1  0.846481724890614];
% mimicing fspecial('gaussian', 3, 3)

% filter the image with the kernel
% gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
M = size(img,1);
N = size(img,2);
for chind = 1:3
    myimg = real( ifft2( fft2( img(:,:,chind), M + 2, N + 2  ).*fft2(mykernel, M+2,N+2) ) );
    myimg = myimg(2:end-1,2:end-1);
    gfrgb(:,:,chind) = myimg;
end

%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------
% cform = makecform('srgb2lab', 'whitepoint', whitepoint('d65'));
% lab = applycform(gfrgb,cform);
%---------------------------------------------------------
% Compute Lab average values (note that in the paper this
% average is found from the unblurred original image, but
% the results are quite similar)
%---------------------------------------------------------
[l a b] = RGB2Lab(gfrgb(:,:,1),gfrgb(:,:,2), gfrgb(:,:,3));

 lm = mean(mean(l));
 am = mean(mean(a));
 bm = mean(mean(b));
%---------------------------------------------------------
% Finally compute the saliency map and display it.
%---------------------------------------------------------
sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
figure
[XX,YY]=meshgrid([1:size(l,1)],[1:size(l,2)]);
 mesh(XX',YY',sm)
%---------------------------------------------------------
