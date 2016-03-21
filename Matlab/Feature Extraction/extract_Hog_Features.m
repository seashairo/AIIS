function [featureVectors] = extract_Hog_Featues(images, imY, imX)
%EXTRACT_HOG_FEATUES Returns a matrix of feature vectors for a matrix of images
%input = images to be processed, and the size to reshape them by.
%output = vectors of each image processed.

for ii = 1 : size(images,1)
    image = images(ii,:);
    image = reshape(image, [imY, imX]);
    featureVectors(ii,:) = hog_Feature_Calc(image);
end

