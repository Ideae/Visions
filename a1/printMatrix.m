function printMatrix( M )
%PRINTMATRIX Summary of this function goes here
%   Detailed explanation goes here
str = mat2str(M,3);
str = strrep(str, ' ', '\t');
str = strrep(str, ';', '\n');
str = strrep(str, '[', '');
str = strrep(str, ']', '');
fprintf(strcat(str,'\n'));
end