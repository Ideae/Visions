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
        for j = 1:2:matchnum
            s = BDiff(j) + BDiff(j+1);
            if s <d
                count = count+1;
            end
        end

        if count > bestCount
            bestX = X;
            bestCount = count;
            bestMatch = matches(:,pta);
        end
    end

    I = [bestX(1),bestX(3),0;
        bestX(2),bestX(4),0;
        bestX(5),bestX(6),1];
    affineTransform = affine2d(I);
    RinLeft = imref2d(size(imgFullLeft));
    [warpedLeft, Rout] = imwarp(imgFullLeft,RinLeft, affineTransform);
    RinRight = imref2d(size(imgFullRight));
    [C, RC] = imfuse(imgFullRight,RinRight,warpedLeft,Rout, 'blend');
    imshow(C, RC);
end

