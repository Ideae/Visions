sigma = 2;
width = sigma*6+1;
gaussBoth = fspecial('gaussian', width, sigma);
gaussX = fspecial('gaussian', [1,width], sigma);
gaussY = fspecial('gaussian', [width,1], sigma);

im2 = rgb2gray(im2double(imread('image2.jpg')));
%both
tic;
imBoth = imfilter(im2, gaussBoth, 'conv');
timeBoth = toc;

%seperate
tic;
tic;
imX = imfilter(im2, gaussX, 'conv');
imY = imfilter(imX, gaussY, 'conv');
imXY = imX + imY;
timeSeperate = toc;

fprintf('timeBoth = %d\ntimeSepeate = %d\n',timeBoth,timeSeperate);
