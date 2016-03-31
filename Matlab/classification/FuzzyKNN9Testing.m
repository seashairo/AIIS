function [ prediction,confidences] = FuzzyKNN9Testing( model, testImages)
% Tests a set of passed in images with the KNN classifier and 9 neighbours.

    prediction = [];
    confidences = [];
    for i = 1 : size(testImages, 1)
        [predictions, confidence] = fuzzyPredictNN(model, testImages(i, :), 9);
        prediction = [prediction; predictions];
        confidences = [confidences;confidence];
    end
end