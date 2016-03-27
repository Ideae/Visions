function [ meldedImage ] = AffineMeldImages( image1, image2, scale, N, d )

    imgFullLeft = imresize(image1, scale);
    imgFullRight = imresize(image2, scale);
    imgLeft = im2single(rgb2gray(imgFullLeft));
    imgRight = im2single(rgb2gray(imgFullRight));
    
    [fLeft, dLeft] = vl_sift(imgLeft) ;
    [fRight, dRight] = vl_sift(imgRight) ;
    [matches, ~] = vl_ubcmatch(dLeft, dRight) ;
    matchnum = size(matches,2);
    bestX = [];
    bestCount = 0;
    bestInliers =[];
    [Atest, Btest] = CreateStack(matches, fLeft, fRight, 1:matchnum);
    for i= 1:N
        pta = randi(matchnum);
        ptb = randi(matchnum);
        while ptb == pta 
            ptb = randi(matchnum);
        end
        ptc = randi(matchnum);
        while ptc == ptb || ptc == pta
            ptc = randi(matchnum);
        end
        [A,B] = CreateStack(matches, fLeft, fRight, [pta,ptb,ptc]);
        iA = pinv(A);
        X=iA*B;

        BModel = Atest*X;
        BDiff = (BModel-Btest).^2;
        count = 0;
        inlierIndices = [];
        for j = 1:2:matchnum*2
            s = BDiff(j) + BDiff(j+1);
            if s <d
                count = count+1;
                inlierIndices = [inlierIndices ;((j-1)/2 +1)];
            end
        end

        if count > bestCount
            bestX = X;
            bestCount = count;
            bestMatch = matches(:,pta);
            bestInliers = inlierIndices;
        end
    end
    [AInliers, BInliers] = CreateStack(matches, fLeft, fRight, bestInliers');
    iAInliers = pinv(AInliers);
        bestX=iAInliers*BInliers;
        
    I = [bestX(1),bestX(3),0;
        bestX(2),bestX(4),0;
        bestX(5),bestX(6),1];
    affineTransform = affine2d(I);
    RinLeft = imref2d(size(imgFullLeft));
    [warpedLeft, Rout] = imwarp(imgFullLeft,RinLeft, affineTransform);
    LeftMask = ones(size(imgFullLeft));
        RightMask = ones(size(imgFullRight));
    [warpedLeftMask, ~] = imwarp(LeftMask,RinLeft, affineTransform);
    RinRight = imref2d(size(imgFullRight));
    [C, RC] = imfusecustom(imgFullRight,RinRight,warpedLeft,Rout, 'custom', RightMask, warpedLeftMask);
    imshow(C, RC);
end

