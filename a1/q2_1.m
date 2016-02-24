function canny(im)
    sobelY = fspecial('sobel');
    sobelX = sobelY';
    sigma = 3;
    width = sigma*6+1;
    gauss = fspecial('gaussian', width, sigma);

    derivGaussY = imfilter(gauss, sobelY, 'conv');
    derivGaussX = imfilter(gauss, sobelX, 'conv');

    convdY = imfilter(im, derivGaussY, 'conv');
    convdX = imfilter(im, derivGaussX, 'conv');
    imshow(convdY,[]);
    pause;
    imshow(convdX,[]);
    pause;

    gradientMag = sqrt(convdX.^2 + convdY.^2);
    imshow(gradientMag,[]);
    pause;
    
    gradientOrient = atan2(convdY, convdX);
    imshow(gradientOrient,[]);
    colormap jet
    pause;
end

function q2_1()
    imFruit = rgb2gray(im2double(imread('bowl-of-fruit.jpg')));
    canny(imFruit);

    otherImage = rgb2gray(im2double(imread('image3.jpg')));
    canny(otherImage);
end