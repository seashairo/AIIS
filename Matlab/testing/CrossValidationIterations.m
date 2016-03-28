function [ accuracy, mostAccRatio, maxAccuracy] = CrossValidationIterations( images, labels, modelFunction, testFunction, maxTrainRatio, iterations, seed )
%This function iterates through CrossValidation with a number of
%segmentations of the data set. Each iteration segments the data with a
%different ratio of trainRatio to testRatio, with testRatio being fixed and
%trainRatio varying from 1 up to maxTrainRatio.

%This ensures at least one ratio is tested, that of a 1:1 split.
    if maxTrainRatio < 1
        maxTrainRatio = 1;
    end
    
    accuracies = [];
    
    for i=1:maxTrainRatio
        % If a seed is provided, pass it to the CrossValidation function.
        % Otherwise, perform an unseeded iteration. This allows for
        % consistency in produced results if desired.
        if nargin == 7
            accuracy = CrossValidation(images, labels, modelFunction, testFunction, i, 1, iterations, seed);
        else
            accuracy = CrossValidation(images, labels, modelFunction, testFunction, i, 1, iterations);
        end
        accuracies = [accuracies;accuracy];
    end
    %This returns the average accuracy value of the tested iterations
    accuracy = sum(accuracies) / maxTrainRatio;
    
    %This returns the testratio that produced the highest accuracy result
    [maxAccuracy,mostAccRatio] = max(accuracies);
end

