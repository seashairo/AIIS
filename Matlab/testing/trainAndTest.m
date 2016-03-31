function [ accuracy, results, trainTime, testTime ] = trainAndTest( images, labels, modelFunction, testData, testLabels, testFunction )
% Builds a model using the modelFunction, images, and labels.
% Then tests the function using testFunction with testImages and
% testLabels.
    tic;
    model = modelFunction(images, labels);
    trainTime=toc;
    tic;
    results = testFunction(model, testData);
    testTime=toc;
    comparison = (testLabels == results);
    accuracy = sum(comparison) / length(comparison);
end

