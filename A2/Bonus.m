function [ ] = Bonus( )
    fprintf('Running Question 2 Part A (Affine)\n');
    imgFullLeft = imread('parliament-left.jpg');
    imgFullRight = imread('parliament-right.jpg');
    fprintf('Running Bonus (Without blending)\n');
    AffineMeldImages(imgFullLeft,imgFullRight,0.25, 200, 1, 'max');
    pause;
    fprintf('Running Bonus (With blending)\n');
    AffineMeldImages(imgFullLeft,imgFullRight,0.25, 200, 1, 'custom');
end

