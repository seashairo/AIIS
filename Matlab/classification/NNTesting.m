function [ prediction ] = NNTesting( model, testImages )
% Tests a set of passed in images with the NN classifier.

    prediction = [];
    for i = 1 : size(testImages, 1)
        prediction = [prediction; predictNN(model, testImages(i, :), 1)];
    end
end

