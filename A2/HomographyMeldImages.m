function [ meldedImage ] = HomographyMeldImages( image1, image2, scale, N, d )
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
    [Atest] = CreateHomographyA(matches, fLeft, fRight, 1:matchnum);
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
        ptd = randi(matchnum);
        while ptd == pta || ptd == ptb || ptd == ptc
            ptd = randi(matchnum);
        end
%         [A,B] = CreateStack(matches, fLeft, fRight, [pta,ptb,ptc]);
%         iA = pinv(A);
%         X=iA*B;
        A = CreateHomographyA(matches, fLeft, fRight, [pta,ptb,ptc,ptd]);
        [~,~,V] = svd(A);
        X = V(:,end);
        
        BModel = Atest*X;
        BDiff = BModel.^2;
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

    H = [bestX(1),bestX(2),bestX(3);
        bestX(4),bestX(5),bestX(6);
        bestX(7),bestX(8),bestX(9)]';
    homographyTransformation = projective2d(H);
    RinLeft = imref2d(size(imgFullLeft));
    [warpedLeft, Rout] = imwarp(imgFullLeft,RinLeft, homographyTransformation);
    
    LeftMask = ones(size(imgFullLeft));
        RightMask = ones(size(imgFullRight));
    [warpedLeftMask, ~] = imwarp(LeftMask,RinLeft, homographyTransformation);
    RinRight = imref2d(size(imgFullRight));
    [C, RC] = imfusecustom(imgFullRight,RinRight,warpedLeft,Rout, 'custom', RightMask, warpedLeftMask);
%     imshow(C, RC);
    meldedImage = C;
end

