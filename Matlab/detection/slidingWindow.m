function [windows, boxPoint] = slidingWindow(image, winY, winX, stepY, stepX, direction)
% SLIDINGWINDOW Splits up a image into discrete windows
% goes through an image at a specific rate spliting it.
% returns a matrix of the segments, and the boxpoints.
% image --> the image to be processed. 
% winY, winX --> the size of the cutout window.
% stepY, stepX --> the amount of change of the starting pixel per
% iteration default 1/3 of the size of the window in both directions.
% direction --> 0 for horizontal 1 for vertical default 0.

if nargin < 4
    arg4 = winY/3;
end

if nargin < 5
    arg5 = winX/3;
end

if nargin < 6
    arg6 = 0;
end

topLeftCol = 1;
topLeftRow = 1;

% Transpose the matrix for vertical Movement.
if direction == 1
    image = permute(image,[2,1,3]);
end

[bottomRightCol, bottomRightRow, ~] = size(image);

fcount = 1;
windows = [];

% Loops through entire image and extracts windows
for jj = topLeftCol : stepY : bottomRightCol-winY
    for ii = topLeftRow : stepX : bottomRightRow-winX;
        % top left corner of rectangle.
        p1 = [ii,jj];
        p2 = [winX-1, winY-1];
        % bottom right corner of rectangle.
        cutout = [p1, p2];
        window = imcrop(image,cutout);
        
        % Flip the image back after creating a cutout.
        if direction == 1
            window = permute(window,[2,1,3]);
            imshow(window);
        end
        
        windowGray = rgb2gray(window);
        imVector = reshape(windowGray, 1, size(windowGray,1), size(windowGray, 2));
        windows = [windows; imVector];
        
        boxPoint(fcount,:) = [ii,jj];
        fcount = fcount+1;
    end
end
end

