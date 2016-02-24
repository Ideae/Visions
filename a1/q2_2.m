function q2_2()
im = rgb2gray(im2double(imread('image2.jpg')));
seperate = setGaussian(im, 3);
imshow(seperate,[]);
end

function res = setGaussian(im, sigma)
    width = sigma*6+1;
    vertFilter = fspecial('gaussian', [width, 1], sigma);
    horzFilter = fspecial('gaussian', [1, width], sigma);
    res = imfilter(im, vertFilter, 'conv');
    res = imfilter(res,horzFilter, 'conv');
end