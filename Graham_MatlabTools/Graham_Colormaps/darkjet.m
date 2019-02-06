%Useful colormap that is only dark colors
function colors = darkjet(num)
    load('darkjet.mat')
    colors = downsample(darkjet_color,floor(size(darkjet_color,1)/num));
    colors = colors(1:end,:);
end