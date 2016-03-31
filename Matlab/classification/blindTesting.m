function [ prediction, confidences ] = blindTesting( model, testImages )
%This classifier exists purely to serve as a baseline system. It assigns a
%classification of "person" to literally everything with 100%
prediction = ones(size(testImages,1),1);
confidences = ones(size(testImages,1),1);
end

