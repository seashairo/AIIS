function [ prediction ] = predictNN( model, testImage )
% Tests an image, testImage, against a NN model and returns the closest
% prediction possible.

    minDistance = Inf;
    minLabel = 0;
    
    % Get the minimum euclidean distance & associated label from the test
    % image to the samples in the model.
    for i=1:size(model.samples, 1)
        distance =  euclideanDistance(testImage, model.samples(i, :));
        if distance < minDistance
            minDistance = distance;
            minLabel = model.labels(i);
        end
    end
    
    prediction = minLabel;
end

