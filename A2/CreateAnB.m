function [ A, B ] = CreateAnB( match, fLeft, fRight )
    a1 = fLeft(:,match(1));
    a2 = fRight(:,match(2));
    A = [
        a1(1), a1(2), 0, 0, 1, 0;
        0,0,a1(1), a1(2),0,1;];
    B = [
        a2(1);a2(2);];
end

