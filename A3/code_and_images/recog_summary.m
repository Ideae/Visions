fprintf('Part 1: Recognition. Our approach:\nWe reduced our cellSize of our hog features from 6 to 4, in order to get more features from our images.\n');
fprintf('We also changed our lambda from 0.1 to 0.01 as this produced a greater accuracy after several trials.\n');
fprintf('We used false positives produced from part 2 to introduce more negatives into the training set (hard negative mining).\n');
fprintf('Accuracy results from validation set:\n');
fprintf('  accuracy:   0.996\n  true  positive rate: 0.496\n  false positive rate: 0.000\n  true  negative rate: 0.500\n  false negative rate: 0.004\n');
pause;