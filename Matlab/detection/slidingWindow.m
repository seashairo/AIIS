function [windows, boxPoints] = slidingWindow(image, winY, winX, stepY, stepX, direction)
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

imgray = rgb2gray(image);
image = im2double(imgray);
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
        % bottom right corner of rectangle.
        p2 = [winX-1, winY-1];
        cutout = [p1, p2];
        window = imcrop(image,cutout);
        
        % Flip the image back after creating a cutout.
        if direction == 1
            window = permute(window,[2,1,3]);
        end
        windowResize = imresize(window,[160, 96]);
        imVector = reshape(windowResize, 1, size(windowResize,1) * size(windowResize, 2));
        windows = [windows; imVector];
        
        boxPoints(fcount,:) = [ii,jj];
        fcount = fcount+1;
    end
end
end