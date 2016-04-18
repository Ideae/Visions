im_zack = imread('zack.png');
im_dante = imread('dante.png');
%and we're here to pump you up.

im_zack = double(rgb2gray(im_zack))/255;
im_dante = double(rgb2gray(im_dante))/255;

im_zack = (im_zack + 1) /2;

im_dante = (im_dante *2) -1;
[imh, imw] = size(im_zack);
%They're the same size...

% Uncomment for dank dacks
% widths = [17,19,21,25,27,31,41,51,71];
% widths = [11]; %for zante
widths = [19]; %for dack

for i = 1:numel(widths)
	width = widths(i)
	sigma = (width - 1) / 6;
	f = fspecial('gaussian', width , sigma);
	f = padarray(f, [imh imw]-(2*sigma*3+1), 'post');
	f = circshift(f, -3*[sigma sigma]);
	f_dft = fft2(f, imh, imw);
	im_dft_z = fft2(im_zack, imh, imw);
	im_f_dft_z = im_dft_z .* f_dft;
	im_f_z = ifft2(im_f_dft_z);
    
    f = fspecial('gaussian', width, sigma);
	f = padarray(f, [imh imw]-(2*sigma*3+1), 'post');
	f = circshift(f, -3*[sigma sigma]);
	f_dft = fft2(f, imh, imw);
    f_dft = 1-f_dft;
    
    im_dft_d = fft2(im_dante, imh, imw);
	im_f_dft_d = im_dft_d .* f_dft;
	im_f_d = ifft2(im_f_dft_d);
    
    imshow(im_f_d);
    pause;
    imshow(im_f_z);
    pause;
    im_zanta = im_f_d + im_f_z;
    %arrrrrrr
    imshow(im_zanta);
    pause;
    
    
end