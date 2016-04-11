function plotBox( bbox, confidence )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    clamp = min(1, max(0, confidence/2));
    plot_rectangle = [bbox(1), bbox(2);
                      bbox(1), bbox(4);
                      bbox(3), bbox(4);
                      bbox(3), bbox(2);
                      bbox(1), bbox(2)];
    plot(plot_rectangle(:,1), plot_rectangle(:,2),'Color', [1-clamp 0 clamp]);

end

