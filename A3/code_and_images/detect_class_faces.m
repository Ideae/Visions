run('../vlfeat-0.9.20/toolbox/vl_setup')
imageDir = 'test_images';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);
load('my_svm.mat');
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_names = cell(0,1);

cellSize = 4;
dim = 36;
featSize = dim/cellSize;
scaleFactor = sqrt(sqrt(0.5));
% load and show the image
colorIm = im2single(imread('class.jpg'));
origIm = rgb2gray(colorIm);
%     imshow(im);
%     hold on;

currentScale = 1/scaleFactor;
top_bbs = [];
top_vals = [];
perm = vl_hog('permutation');

fprintf('Detecting faces in class image, please wait..\n');
while true
    fprintf('Working...  ');
    currentScale = currentScale * scaleFactor;
    im = imresize(origIm, currentScale,'lanczos3');
%         im = adapthisteq(im);
    %         im = rgb2gray(imresize(origIm, currentScale));
    [rs,cs,~] = size(im);
    if rs+cellSize < dim || cs+cellSize < dim
        break;
    end
        % generate a grid of features across the entire image. you may want to
        % try generating features more densely (i.e., not in a grid)
        
        feats = vl_hog(im,cellSize);
        feats2 = vl_hog(imadjust(im),cellSize);
        feats3 = vl_hog(histeq(im),cellSize);
        feats4 = vl_hog(adapthisteq(im),cellSize);
        
        passes = cat(4,feats , feats2, feats3,feats4);
        [rows,cols,~] = size(feats);
        confs = zeros(rows,cols);
        
%         imshow(vl_hog('render', feats));
%         pause;
        % concatenate the features into 6x6 bins, and classify them (as if they
        % represent 36x36-pixel faces)
        
        for r=1:rows-(featSize-1)
            for c=1:cols-(featSize-1)
                cc = 0;
                np =4;
                for pp=1:np
                    featHere = passes(r:r+(featSize-1),c:c+(featSize-1),:, pp);
                    featHere2 = featHere (:,end:-1:1,perm, 1);
                    aa = featHere(:)'*w + b;
                    bb = featHere2(:)'*w + b;
                    cc = cc + min(aa, bb);
                end
                confs(r,c) = (cc) / np;
            end
        end
        
        % get the most confident predictions
        [~,baseInds] = sort(confs(:),'descend');
        %     inds = inds(1:20); % (use a bigger number for better recall)
        box_count = 0;
        inds = [];
        
        for n=1:numel(baseInds)
            [row,col] = ind2sub([size(confs,1) size(confs,2)],baseInds(n));
            currConf = confs(row,col);
            bbox = [ (col*cellSize), ...
                (row*cellSize), ...
                ((col+featSize-1)*cellSize), ...
                ((row+featSize-1)*cellSize)]/currentScale;
            take = true;
            intersect_inds = [];
            for j = 1:numel(top_vals)
                bbox2 = top_bbs(j,:);
                if checkOverlap(bbox,bbox2,0.2)
                    if top_vals(j) < currConf
                        
                        intersect_inds = [intersect_inds;j];
                        %                         plot_rectangle = [bbox(1), bbox(2); ...
                        %                         bbox(1), bbox(4); ...
                        %                         bbox(3), bbox(4); ...
                        %                         bbox(3), bbox(2); ...
                        %                         bbox(1), bbox(2)];
                        %                         plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
                        %                       pause;
                    else
                        take = false;
                        break;
                    end
                end
            end
            if currConf < 0.5
                break;
            end
            if take
                
                for j = 1:size(intersect_inds)
                    top_vals(intersect_inds(j)) = -1;
                    top_bbs(intersect_inds(j),:) = [0,0,0,0];
                end
                inds = [inds;baseInds(n)];
                %                 str = struct('val',confs(row,col),'bb',bbox);
                top_bbs = [top_bbs; bbox];
                top_vals = [top_vals; confs(row,col)];
                
                %                 box_count = box_count+1;
                
                %                 plot_rectangle = [bbox(1), bbox(2); ...
                %                 bbox(1), bbox(4); ...
                %                 bbox(3), bbox(4); ...
                %                 bbox(3), bbox(2); ...
                %                 bbox(1), bbox(2)];
                %             plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
                %             pause;
                
                
                %                 if box_count >= 20
                %                     break;
                %                 end
            end
        end
end
[~,top_inds] = sort(top_vals,'descend');


hold off;
imshow(colorIm);
hold on;
for n=1:numel(top_inds)
    %         [row,col] = ind2sub([size(feats,1) size(feats,2)],inds(n));
    
    %         bbox = [ col*cellSize ...
    %             row*cellSize ...
    %             (col+cellSize-1)*cellSize ...
    %             (row+cellSize-1)*cellSize];
    %         conf = confs(row,col);
    ind = top_inds(n);
    
    
    bbox = top_bbs(ind,:);
    conf = top_vals(ind);
    if conf == -1
        continue;
    end
%     image_name = {imageList(i).name};
    clamp = min(1, max(0, conf/2));
    % plot
    plot_rectangle = [bbox(1), bbox(2); ...
        bbox(1), bbox(4); ...
        bbox(3), bbox(4); ...
        bbox(3), bbox(2); ...
        bbox(1), bbox(2)];
    plot(plot_rectangle(:,1), plot_rectangle(:,2),'Color', [1-clamp 0 clamp]);
    
    % save
    %         conf
    bboxes = [bboxes; bbox];
    confidences = [confidences; conf];
end

%          pause;
fprintf('got preds for image %d/%d\n', i,nImages);
