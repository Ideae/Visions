function [ StackA ] = CreateHomographyA( matchList, fLeft, fRight, indexes )
    n = size(indexes);
    StackA= [];
    for i = 1:n(2)
        match = matchList(:,indexes(i));
%         [q,p] = CreateAnB(match, fLeft, fRight);
        a1 = fLeft(:,match(1));
        a2 = fRight(:,match(2));
        A = [
            a1(1), a1(2), 1, 0, 0, 0, -a1(1)*a2(1), -a1(2)*a2(1), -a2(1);
            0,0,0,a1(1), a1(2),1,-a1(1)*a2(2), -a1(2)*a2(2), -a2(2);];
        StackA = [StackA;A];
    end
end

