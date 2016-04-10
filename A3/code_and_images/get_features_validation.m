close all
clear
run('../vlfeat-0.9.20/toolbox/vl_setup')
%validation
pos_imageDir = 'validationSetFaces';
pos_imageList = dir(sprintf('%s/*.jpg',pos_imageDir));
pos_nImages_valid = length(pos_imageList);

neg_imageDir = 'validationSetNotFaces';
neg_imageList = dir(sprintf('%s/*.jpg',neg_imageDir));
neg_nImages_valid = length(neg_imageList);

imgsize = 36;
cellSize = 4;
featSize = 31*(imgsize/cellSize)^2;

pos_feats_valid = zeros(pos_nImages_valid,featSize);
for i=1:pos_nImages_valid
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,pos_imageList(i).name)));
        im = adapthisteq(im);
    feat = vl_hog(im,cellSize);
    pos_feats_valid(i,:) = feat(:);
    fprintf('got feat for pos image %d/%d\n',i,pos_nImages_valid);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

neg_feats_valid = zeros(neg_nImages_valid,featSize);
for i=1:neg_nImages_valid
    im = im2single(imread(sprintf('%s/%s',neg_imageDir,neg_imageList(i).name)));
    feat = vl_hog(im,cellSize);
    neg_feats_valid(i,:) = feat(:);
    fprintf('got feat for neg image %d/%d\n',i,neg_nImages_valid);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

save('pos_neg_feats_validation.mat','pos_feats_valid','neg_feats_valid','pos_nImages_valid','neg_nImages_valid')