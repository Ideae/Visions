fprintf('Part 2: Detection. Our approach:\n');
fprintf('We implemented a sliding window, and scaled the image down by sqrt(0.5) every iteration.\n');
fprintf('Our non-maximum suppression uses a customized overlap detector to aggresively invalidate overlapping faces.\n');
fprintf('We used lanczos3 resampling instead of bicubic when resizing our images to reduce artifacts that contriubted to false positives.\n');
fprintf('We also recalculate the contrast by using value histogram normalization at both the local and global scale\n');
fprintf('We take the average of all contrast operations to determine the true score of the tile.\n');
fprintf('Furthermore, we also use the inverted HOG descriptors at each tile to exploit face symmetry.\n');
imshow(imread('average_precision.png'));
pause;