function [ image ] = addBoxToImage(image, X, Y, width, height)
% ADDBOXTOIMAGE Adds a red bounding box to the designated area embedded in the image

shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',uint8([255 0 0]));
rectangle = int32([X, Y, width, height]);
image = step(shapeInserter, image, rectangle);
end

