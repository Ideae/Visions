function [ s ] = detectFaces( image,w,b, imageName, hogSize, windowSize, scaleFactor, startingScale )
    featSize = windowSize/hogSize;
    currentScale = startingScale/scaleFactor;
    top_bbs = [];
    top_vals = [];
    while true
        currentScale = currentScale * scaleFactor;
        im = imresize(image, currentScale,'lanczos3');
        %         im = rgb2gray(imresize(origIm, currentScale));
        [rs,cs,~] = size(im);
        if rs< windowSize || cs < windowSize
            break;
        end
                
                % generate a grid of features across the entire image. you may want to
                % try generating features more densely (i.e., not in a grid)
                feats = vl_hog(im,hogSize);
                
                % concatenate the features into 6x6 bins, and classify them (as if they
                % represent 36x36-pixel faces)
                [rows,cols,~] = size(feats);
                confs = zeros(rows,cols);
                
                for r=1:rows-(featSize-1)
                    for c=1:cols-(featSize-1)
                        featHere = feats(r:r+(featSize-1),c:c+(featSize-1),:);
                        aa = featHere(:)'*w + b;
                        featHere2 = featHere (:,end:-1:1,vl_hog('permutation'));
                        bb = featHere2(:)'*w + b;
                        confs(r,c) = min(aa, bb);
                    end
                end
                
                % get the most confident predictions
                [~,baseInds] = sort(confs(:),'descend');
                %     inds = inds(1:20); % (use a bigger number for better recall)
                box_count = 0;
                inds = [];
                
                for n=1:numel(baseInds)
                    [row,col] = ind2sub([size(feats,1) size(feats,2)],baseInds(n));
                    currConf = confs(row,col);
                    
                    if currConf < 0.01
                        break;
                    end
                    bbox = [ (col*hogSize), ...
                        (row*hogSize), ...
                        ((col+featSize-1)*hogSize), ...
                        ((row+featSize-1)*hogSize)]/currentScale;
                    take = true;
                    intersect_inds = [];
                    for j = 1:numel(top_vals)
                        bbox2 = top_bbs(j,:);
                        if checkOverlap(bbox,bbox2,0.15)
                            if top_vals(j) < currConf
                                intersect_inds = [intersect_inds;j];
                            else
                                take = false;
                                break;
                            end
                        end
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
    
    [sv,top_inds] = sort(top_vals,'descend');
    top_inds = top_inds(sv > 0);
    ni = numel(top_inds);
    s = {zeros(ni,4), zeros(ni,1), cell(ni,1)};

    for n=1:ni
        ind = top_inds(n);
        s{1}(n,:) = top_bbs(ind,:);
        s{2}(n,:) = top_vals(ind);
        s{3}(n,:) = {imageName};
    end
    
end

