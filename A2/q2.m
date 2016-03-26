
% run('C:\Users\ZackLapt\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
% run('C:\Users\MHDante\Desktop\vlfeat-0.9.20\toolbox\vl_setup')
imgFullLeft = imread('parliament-left.jpg');
imgFullRight = imread('parliament-right.jpg');
% imgFullLeft = imresize(imgFullLeft, 0.25);
% imgFullRight = imresize(imgFullRight, 0.25);
imgLeft = im2single(rgb2gray(imgFullLeft));
imgRight = im2single(rgb2gray(imgFullRight));
%imshow(imgLeft);
% [fLeft, dLeft] = vl_sift(imgLeft) ;
% [fRight, dRight] = vl_sift(imgRight) ;
% [matches, scores] = vl_ubcmatch(dLeft, dRight) ;
% matches = matches(:,1:q);
matchnum = size(matches,2);
bestX = [];
bestCount = 0;
bestMatch = [];
[Atest, Btest] = CreateStack(matches, fLeft, fRight, 1:matchnum);
N= 200;
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
%     iA = inv(A);
    X=A\B;
    
    BModel = Atest*X;
    BDiff = (BModel-Btest).^2;
    d =20^2;
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

% affineTransform = affine2d('affine', I);
% [warpedRight, xdata, ydata] = imtransform(imgRight, affineTransform);
RinLeft = imref2d(size(imgFullLeft));
[warpedLeft, Rout] = imwarp(imgFullLeft,RinLeft, affineTransform);
RinRight = imref2d(size(imgFullRight));
[C, RC] = imfuse(imgFullRight,RinRight,warpedLeft,Rout, 'blend');
imshow(C, RC);
pause;
% oz = size(warpedRight);
% xdata = round(xdata);
% ydata = round(ydata);
% r_size = [ oz(1)-ydata(1), oz(2)-xdata(1)];
% r_size = round(r_size);
% res = zeros(r_size(1),r_size(2));
% sizea = -xdata(1):r_size(2)-1;
% sizeb = -ydata(1):r_size(1)-1;
% res(sizeb, sizea ) = warpedRight;
% [ilsizey,ilsizex] = size(imgLeft);
% res(1:ilsizey,1:ilsizex) = imgLeft;
% 
% imshow(res);
% leftVect = round(fLeft(:,bestMatch(1)));
% r = fRight(:,bestMatch(2));
% r = [307,579];
% AA = [
%     r(1), r(2), 0, 0, 1, 0;
%     0,0,r(1), r(2),0,1;];
% rightVect = round(AA * bestX);
% leftVect = [1767,700];
% % 1767 700 307+579
% offset = [max(leftVect(2),rightVect(2)), max(leftVect(1),rightVect(1))];
% leftPos = [offset(1)-leftVect(2),offset(2)-leftVect(1)];
% rightPos = [offset(1)-rightVect(2),offset(2)-rightVect(1)];
% leftSize = size(imgLeft);
% rightSize = size(warpedRight);
% finalSize = [max(leftPos(1)+leftSize(1),rightPos(1)+rightSize(1)),
%              max(leftPos(2)+leftSize(2),rightPos(2)+rightSize(2))];
% imgFinal = zeros(finalSize(1),finalSize(2));
% imgFinal(leftPos(1)+1:leftPos(1)+leftSize(1),leftPos(2)+1:leftPos(2)+leftSize(2)) = imgLeft;
% % imgFinal(0:2575,0:2556) = imgLeft;
% imgFinal(rightPos(1)+1:rightPos(1)+rightSize(1),rightPos(2)+1:rightPos(2)+rightSize(2)) = warpedRight;
% imshow(imgFinal,[]);
% 
% 
% % imshow(warpedRight,[]);

