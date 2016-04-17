% q1();
% pause;
im = imread('ryerson.jpg');
newImg = SeamCarve(im2double(im), 400);
imshow(newImg, []);
% colormap jet;