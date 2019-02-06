function [output] = normalizeRange(input,a,b)

    interval = b-a;
    output = (((input-min(input(:))).*interval)./(max(input(:)-min(input(:)))))+a;    

end

