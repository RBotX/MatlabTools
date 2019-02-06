function [subplot_rect_height,subplot_rect_length] = calculateSubplots(n)
    subplot_rect_height = ceil(sqrt(n));
    subplot_rect_length = ceil(n/subplot_rect_height);
end

