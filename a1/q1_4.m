width = 13; 
sigma = 2;
kernel1 = fspecial('gaussian', width, sigma);
im1 = rgb2gray(im2double(imread('image1.png')));
res_q1_4a = q1_3(im1,kernel1);
% printMatrix(res_q1_4a);
% fprintf('\n');
res_q1_4b = imfilter(im1, kernel1, 'conv');
% printMatrix(abs(res_q1_4a - res_q1_4b));
diffImage = abs(res_q1_4a - res_q1_4b);
imshow(diffImage,[0,1]);

