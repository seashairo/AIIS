function [ image ] = addBoxToImage(image, X, Y, width, height, Colour)
% ADDBOXTOIMAGE Adds a red bounding box to the designated area embedded in the image
if nargin < 6
    Colour = uint8([255 0 0]);
end

shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',Colour);
rectangle = int32([X, Y, width, height]);
image = step(shapeInserter, image, rectangle);
end

