function [prediction, confidence] = SVMTesting(model,images)
%SVMTESTING2 Summary of this function goes here
%   Detailed explanation goes here
    [prediction, confidence] = predict(model, images);
    
    confidence = max(confidence.').';
end


