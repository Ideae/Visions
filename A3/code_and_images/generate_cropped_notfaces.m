run('C:\Users\ZackLapt\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
% run('C:\Users\MHDante\Desktop\vlfeat-0.9.20\toolbox\vl_setup')

% you might want to have as many negative examples as positive examples
n_have = 0;
n_want = numel(dir('cropped_training_images_faces/*.jpg'));

imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
mkdir(new_imageDir);

dim = 36;

sizeList = numel(imageList);

while n_have < n_want
    % generate random 36x36 crops from the non-face images
    randIndex = randi(sizeList);
    str = strcat(imageDir, '/', imageList(randIndex).name);
    img = imread(str);
    [h,w,~] = size(img);
    hh = randi(h-dim);
    ww = randi(w-dim);
    img = rgb2gray(img(hh:hh+dim-1,ww:ww+dim-1,:));
    n_have = n_have + 1;
    
    str2 = strcat(new_imageDir, '/', num2str(n_have), '.jpg');
    imwrite(img, str2);
%     imshow(img);
%     pause;
end