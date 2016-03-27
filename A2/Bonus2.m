function [  ] = Bonus2( )
bonuscurrent = imread('b12.jpg');
for i = 1:11
    b2 = imread(strcat(strcat('b', num2str(12-i)),'.jpg'));
    bonuscurrent = HomographyMeldImages(bonuscurrent,b2,1, 40000, 0.00001);
    fprintf(strcat('im upset: ', num2str(i)));
    imshow(bonuscurrent);
    pause;
end

    imshow(bonuscurrent);
    pause;
end

