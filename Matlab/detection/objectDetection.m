function [image, objects] = objectDetection(image, model, imY, imX, threshhold)
% ObjectDetection using the sliding window approach

% Segment up the supplied image. Area of imY*imX gets scaled to 160*96 for
% feature extraction.
[windows, boxPoints] = slidingWindow(image, imY, imX, 40, 24, 0);

% Do feature Extraction HOG 
featureVector = extractHogFeatures(windows, 160, 96);

% Classify each window SVM
[predictions, scores] = SVMTesting(model, featureVector);

% Keep the positive predictions above the threshold
objects = [];
fcount = 1;
for ii = 1 : size(predictions,1)  
    if predictions(ii,1) == 1 && scores(ii) > threshhold
        objects(fcount,[1,2]) = boxPoints(ii,[1,2]);
        objects(fcount,3) = scores(ii,1);
        objects(fcount,4) = imY;
        objects(fcount,5) = imX;
        fcount = fcount + 1;
    end
end
end