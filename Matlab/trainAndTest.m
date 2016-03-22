function [ accuracy ] = trainAndTest( images, labels, modelFunction, testData, testLabels, testFunction )
% Does a thing.

    model = modelFunction(images, labels);
    results = testFunction(model, testData);
    comparison = (testLabels == results);
    accuracy = sum(comparison) / length(comparison);
end

