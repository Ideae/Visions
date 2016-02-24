function res = canny(im)
    sobelY = fspecial('sobel');
    sobelX = sobelY';
    sigma = 3;
    width = sigma*6+1;
    gauss = fspecial('gaussian', width, sigma);

    derivGaussY = imfilter(gauss, sobelY, 'conv');
    derivGaussX = imfilter(gauss, sobelX, 'conv');

    convdY = imfilter(im, derivGaussY, 'conv');
    convdX = imfilter(im, derivGaussX, 'conv');
    imshow(convdY,[]);
    pause;
    imshow(convdX,[]);
    pause;

    gradientMag = sqrt(convdX.^2 + convdY.^2);
    imshow(gradientMag,[]);
    pause;
    
    gradientOrient = atan2(convdY, convdX);
    imshow(gradientOrient,[]);
    colormap jet
    pause;
    
    imNonMaxSupress = zeros(size(gradientMag));
    [width,height] = size(gradientMag);
    
    gradientMag = padarray(gradientMag,[1,1]);
    
    convdY = padarray(convdY,[1,1]);
    convdX = padarray(convdX,[1,1]);
    
    for row = 2:width-1
        for col = 2:height-1
            middle = gradientMag(row,col);
            if (middle ~= 0)
                unit = [convdY(row,col), convdX(row,col)]/middle;
            else
                continue;
            end
            urow = row-round(unit(1));
            ucol = col-round(unit(2));
            
            %fprintf('%d %d \n', unit);
            lessBool = middle > gradientMag(urow,ucol);
            urow = row+round(unit(1));
            ucol = col+round(unit(2));
            moreBool = middle > gradientMag(urow,ucol);
            
            if (lessBool && moreBool)
                imNonMaxSupress(row, col) = middle;
            else
                imNonMaxSupress(row, col) = 0;
            end
        end
    end
res = imNonMaxSupress;
end