function [ prediction ] = FuzzyKNN9HighWeightTesting( model, testImages)
% Tests a set of passed in images with the KNN classifier and 9 neighbours.

    prediction = [];
    for i = 1 : size(testImages, 1)
        prediction = [prediction; fuzzyPredictNN(model, testImages(i, :), 9, 5)];
    end
end