function [ prediction ] = KNN9Testing( model, testImages )
% Tests a set of passed in images with the KNN classifier and 9 neighbours.

    prediction = [];
    for i = 1 : size(testImages, 1)
        prediction = [prediction; predictNN(model, testImages(i, :), 9)];
    end
end
