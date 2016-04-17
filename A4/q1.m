im = imread('spat_freq.png');

im = double(rgb2gray(im))/255;

[imh, imw] = size(im);

widths = [3,5,7,13,21,31,41,51,71];
timesSpatial = [];

for i = 1:numel(widths)
	
	width = widths(i);
	sigma = (width - 1) / 6;
	f = fspecial('gaussian', width, sigma);
	tic;
	convd = conv2(im, f);
	timeTaken = toc;
	timesSpatial = [timesSpatial;timeTaken];
% 	imshow(convd, []);
% 	pause;
end

timesFreq = [];
for i = 1:numel(widths)
	width = widths(i);
	sigma = (width - 1) / 6;
	f = fspecial('gaussian', width, sigma);
	tic;
	f = padarray(f, [imh imw]-(2*sigma*3+1), 'post');

	f = circshift(f, -3*[sigma sigma]);

	im_dft = fft2(im, size(im,1), size(im,2));

	f_dft = fft2(f, size(im,1), size(im,2));

	im_f_dft = im_dft .* f_dft;

	im_f = ifft2(im_f_dft);
	timeTaken = toc;
	timesFreq = [timesFreq;timeTaken];
% 	imshow(im_f, []);
% 	pause;
end
plot(widths, [timesSpatial, timesFreq] );
title('Benchmark of Filtering Execution Time on Spatial vs Frequency Domain')
legend('conv2', 'DFT');
xlabel('Kernel Width');
ylabel('Time');

fprintf('Based on this data, assuming that the growth of the function between kernel size and execution time follows the trend seen, we conclude that the execution time for the conv2 in the spatial domain grows linearly, while the dft frequency domain stays roughly constant. Therefore, for width sizes less than approximately 35, the conv2 is faster, but for any widths greater than 35 it is faster to use the dft.\n');


