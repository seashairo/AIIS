function [ accuracy, results ] = trainAndTest( images, labels, modelFunction, testData, testLabels, testFunction )
% Builds a model using the modelFunction, images, and labels.
% Then tests the function using testFunction with testImages and
% testLabels.
    model = modelFunction(images, labels);
    results = testFunction(model, testData);
    comparison = (testLabels == results);
    accuracy = sum(comparison) / length(comparison);
end

