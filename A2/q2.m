
% run('C:\Users\ZackLapt\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
% run('C:\Users\MHDante\Desktop\vlfeat-0.9.20\toolbox\vl_setup')

imgFullLeft = imread('parliament-left.jpg');
imgFullRight = imread('parliament-right.jpg');
AffineMeldImages(imgFullLeft,imgFullRight,0.25, 200, 1);
