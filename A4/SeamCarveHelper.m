function [ res ] = SeamCarveHelper( filename, newWidth, newHeight, saveName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
im = imread(filename);
newImg = SeamCarve(im2double(im), newWidth);
newImg = SeamCarve(permute(newImg, [2 1 3]), newHeight);
newImg = permute(newImg, [2 1 3]);
fprintf('Showing final carve image and writing to disk: ');
fprintf(saveName);
fprintf('\n');
imshow(newImg, []);
imwrite(newImg,[saveName,'.jpg']);
res = newImg;
end

