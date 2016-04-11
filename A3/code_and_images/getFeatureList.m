function [ feats, featureAmount ] = getFeatureList( imgdir, imgsize, cellSize )
    featSize = 31*(imgsize/cellSize)^2;
    imageList = dir(sprintf('%s/*.jpg',imgdir));
    featureAmount = length(imageList);
    feats = zeros(featureAmount,featSize);
    for i=1:featureAmount
        im = im2single(imread(sprintf('%s/%s',imgdir,imageList(i).name)));
        feat = vl_hog(im,cellSize);
        a = feat(:);
        feats(i,:) = a;
        fprintf('got feat for pos image %d/%d\n',i,featureAmount);
    %     imhog = vl_hog('render', feat);
    %     subplot(1,2,1);
    %     imshow(im);
    %     subplot(1,2,2);
    %     imshow(imhog)
    %     pause;
    end
end

