function q2_1()

    otherImage = rgb2gray(im2double(imread('image3.jpg')));
    imshow(canny(otherImage),[]);
    pause;
    imFruit = rgb2gray(im2double(imread('bowl-of-fruit.jpg')));
    imshow(canny(imFruit),[]);
    pause;

end