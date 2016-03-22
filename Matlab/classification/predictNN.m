function [ prediction ] = predictNN( model, testImage, K )
% Tests an image, testImage, against a NN model and returns the closest
% prediction possible.
% If K is given, uses the nearest K neighbours instead of single nearest.
    minLabel = 0;

    if nargin == 2 || K == 1
        % Single NN
        minDistance = Inf;
        % Get the minimum euclidean distance & associated label from the test
        % image to the samples in the model.
        for i=1:size(model.samples, 1)
            distance = euclideanDistance(testImage, model.samples(i, :));
            if distance < minDistance
                minDistance = distance;
                minLabel = model.labels(i);
            end
        end
    else
        % K Nearest Neighbours
        minDistances = [];
        for i=1:K
           minDistances(i, :) = [Inf, 0];
        end

        for i=1:size(model.samples, 1)
            distance = euclideanDistance(testImage, model.samples(i, :));
            [maxVal maxIndex] = max(minDistances(:, 1));
            % If distance is less than the highest value in minDistances
            % then it deserves that spot.
            if distance < maxVal
                minDistances(maxIndex, :) = [distance, model.labels(i)];
            end
        end
        minLabel = mode(minDistances(:, 2));
    end
    
    prediction = minLabel;
end

