

function q2_3()
    import java.util.LinkedList
    
    imFruit2 = rgb2gray(im2double(imread('bowl-of-fruit.jpg')));
    canny1 = canny(imFruit2);
    highThresh = 0.2;
    lowThresh = 0.01;
    highIm = canny1 > highThresh;
    imshow(highIm,[]);
    pause;
    lowIm = canny1 > lowThresh;
    imshow(lowIm,[]);
    pause;
    
    output = zeros(size(canny1));
    
    [height, width] = size(highIm);
    queue = LinkedList();
    for row = 1:height
        for col = 1:width
            if (highIm(row,col) == 1)
%                 output(row,col)=1;
                queue.add([row,col]);
            end
        end
    end
    
    while ~queue.isEmpty()
        
        temp = queue.remove();
        row = temp(1);
        col = temp(2);
        if (output(row,col) == 1) 
            continue;
        end
        output(row,col)=1;
        for r = -1:1
            for c = -1:1
                rr = r + row;
                cc = c + col;
                if (output(rr,cc) == 1) 
                    continue;
                end
                if (lowIm(rr,cc) == 1)
                    queue.add([rr,cc]);
                end
            end
        end
    end
    
    imshow(output,[]);
end

