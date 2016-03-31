function [ accuracy, consistentlyMislabelled, trainingTimes, testingTimes ] = CrossValidation(images, labels, modelFunction, testFunction, trainRatio, testRatio, iterations, seed)
%This method takes a set of images and a set of labels generates from them
%a number of ratio-based splits of them into two sets, a testing set and a
%training set. Each split is then tested with the source 
%Note that a proportionally higher trainRatio may result in overfitting,
%while a proportionally lower trainRatio may result in an insufficiently
%trained classifier

%If no valid iteration number is provided, the algorithm attempts to
%default to the number of total permutations with the provided ratios, or
%10! if said value is predicted to be too high.
if nargin < 7 || iterations < 1
    if testRatio + trainRatio <= 10
        iterations = factorial(testRatio + trainRatio) / factorial(max(testRatio,trainRatio));
    else
        iterations = factorial(10);
    end
end

%If a seed is provided, the function resets the random number generator
%using that seed. This allows for consistency in results if desired.
%Otherwise, the function uses the already active rng seed.
if nargin >=8
    rng(seed);
end

accuracies = [];
consistentlyMislabelled = [];

%This loop creates iteration many test-training sets and passes them to the
%testing and training function with the chosen classification method.
    consistentlyMislabelled = zeros(size(images,1));
    trainingTimes = [];
    testingTimes = [];
for i=1:iterations
    [trainImages, trainLabels, testImages, testLabels, testIndices] = splitDataSet(images, labels, trainRatio, testRatio);
    [accuracy,results,trainTime,testTime] = trainAndTest(trainImages,trainLabels,modelFunction,...
        testImages,testLabels, testFunction);
    
    trainingTimes=[trainingTimes;trainTime];
    testingTimes=[testingTimes;testTime];
    %This calculates which images every iteration of the loop has
    %incorectly classified.
    idx=1;
    for j=1:size(images,1)
        if testIndices(j)
            if labels(j) == results(idx)
                consistentlyMislabelled(j) = -1;
            else
                consistentlyMislabelled(j) = consistentlyMislabelled(j) + 1;
            end
            idx=idx+1;
        end
    end
    accuracies = [accuracies;accuracy];
end

%If every iteration of the loop that considered an image as a test image
%incorrectly classified it, 1 is returned, otherwise 0.
consistentlyMislabelled(consistentlyMislabelled > 0) = 1;

%This calculates the average of the accuracy results to determine the
%average accuracy of the method based off of the provided ratios of
%training and testing.
accuracy = sum(accuracies) / iterations;

end

