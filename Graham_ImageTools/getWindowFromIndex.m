%DESCRIPTION: given a coordinate in an image an width and height of a rectangle (dx and dy), will return the indices
%corresponding to the location of the retangle within the image 
%***ROTATIONALLY INVARIANT*** (x and y don't necessarily correspond to horizontal and vertical coordinates)
%***This could easily be expanded to draw an n-dimensional polygon from an n-dimensional image.

%INPUT: 
%---------------------------------------------------------------
% x: (scalar) first coordination
% y: (scalar) second coordination
% dx: (scalar) size of rectangle in x direction
% dy: (scalar) size of rectangle in y direction
% xCentered: (boolean) is the x coordinate the center of the rectangle to be retrieved along the x-axis?
% yCentered: (boolean) is the y coordinate the center of the rectangle to be retrieved along the y-axis?

%OUTPUT:
% xStart: (scalar) row-wise calculated starting point of rectangle (window)
% xEnd: (scalar) row-wise calculated ending point of rectangle (window)
% yStart: (scalar) column-wise calculated starting point of rectangle (window)
% yEnd: (scalar) column-wise calculated ending point of rectangle (window)

%--------------------------------------------------------------------------------------------------
%Example: [xStart,xEnd,yStart,yEnd,center] = getWindowFromIndex(20,30,10,5,1,1);
%xStart = 15; xEnd = 25;
%yStart = 28; yEnd = 32;
%center = [20,30]
%
%you could now use this to index into an image: 
%subImg = image(xStart:xEnd,yStart:yEnd);
%--------------------------------------------------------------------------------------------------

function [xStart,xEnd,yStart,yEnd,center] = getWindowFromIndex(x,y,dx,dy,xCentered,yCentered)

    x = floor(x);
    y = floor(y);
    if xCentered
        xStart = ceil(x - (dx./2));
        xEnd = floor(x + (dx./2));
    else
        xStart = x;
        xEnd = (x+dx)-1;
    end
    if yCentered
        yStart = ceil(y - (dy./2));
        yEnd = floor(y + (dy./2));
    else
        yStart = y;
        yEnd = (y+dy)-1;
    end
	
	center = [floor((xStart+xEnd)./2), floor((yStart+yEnd)./2)];
	
end