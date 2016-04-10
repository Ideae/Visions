function isOverlapping = checkOverlap( bbox1, bbox2, threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    bi=[max(bbox1(1),bbox2(1)) ; max(bbox1(2),bbox2(2)) ; min(bbox1(3),bbox2(3)) ; min(bbox1(4),bbox2(4))];
    iw=bi(3)-bi(1)+1;
    ih=bi(4)-bi(2)+1;
    isOverlapping = false;
    if iw>0 && ih>0       
        % compute overlap as area of intersection / area of union
        ua=(bbox1(3)-bbox1(1)+1)*(bbox1(4)-bbox1(2)+1)+...
           (bbox2(3)-bbox2(1)+1)*(bbox2(4)-bbox2(2)+1)-...
           iw*ih;
%         w1=bbox1(3)-bbox1(1)+1;
%         h1=bbox1(4)-bbox1(2)+1;
%         w2=bbox2(3)-bbox2(1)+1;
%         h2=bbox2(4)-bbox2(2)+1;
%         ua = min(w1*h1,w2*h2);
        ov=iw*ih/ua;
        isOverlapping = ov>threshold;
    end
        
end
