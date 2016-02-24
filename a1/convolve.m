function c = convolve( image, kernel )
%CONVOLVE  a convolution function that takes in as input an arbitrary image and kernel

    [kernelh,kernelw] = size(kernel); 
    kkw = (kernelw-1)/2; %(kw-mod(kw,2))/2;
    kkh = (kernelh-1)/2; %(kh-mod(kh,2))/2;
    image = padarray(image,[kkh,kkw]);
    [ih,iw] = size(image);
    result = zeros(ih,iw);
    
    for icol = kkw+1:iw-kkw
        for irow = kkh+1:ih-kkh
            total = 0;
            for kcol = -kkw:kkw
                for krow = -kkh:kkh
                    %xa = irow-(krow-1)+kkh;
                    %ya = icol-(kcol-1)+kkw;
                    %xb = kh-(krow-1);
                    %yb = kw-(kcol-1);
                    %total = total + image(xa, ya) * kernel(xb,yb);
                    u = krow+kkh+1;
                    v = kcol+kkw+1;
                    total = total + kernel(u,v) * image(irow-krow, icol-kcol);
                end
            end
            result(irow,icol) = total;
        end
    end
    c = result(kkh+1:ih-kkh,kkw+1:iw-kkw);
end