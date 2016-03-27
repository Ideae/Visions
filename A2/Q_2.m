function [ ] = Q_2( )
    %part A: affine
    fprintf('Running Question 2 Part A (Affine)\n');
    imgFullLeft = imread('parliament-left.jpg');
    imgFullRight = imread('parliament-right.jpg');
    AffineMeldImages(imgFullLeft,imgFullRight,0.25, 200, 1, 'max');
    pause;
    %part B: homography
    fprintf('Running Question 2 Part B (Homography)\n');
    imgFullLeft2 = imread('Ryerson-left.jpg');
    imgFullRight2 = imread('Ryerson-right.jpg');
    HomographyMeldImages(imgFullLeft2,imgFullRight2,0.25, 40000, 0.00001);
end

