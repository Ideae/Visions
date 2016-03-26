function [ StackA, StackB ] = CreateStack( matchList, fLeft, fRight, indexes )
    n = size(indexes);
    StackA= [];
    StackB= [];
    for i = 1:n(2)
        match = matchList(:,indexes(i));
        [q,p] = CreateAnB(match, fLeft, fRight);
        StackA = [StackA;q];
        StackB = [StackB;p];
    end
end

