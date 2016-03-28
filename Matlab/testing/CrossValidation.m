function [ accuracy ] = CrossValidation(images, labels, modelFunction, testFunction, trainRatio, testRatio, iterations, seed)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 6 || testRatio < 1
    if nargin < 5 || trainRatio < 1
        trainRatio = 1;
    end
    testRatio = 1;
end
if nargin < 7 || iterations < 1
    if testRatio + trainRatio <= 10
        iterations = factorial(testRatio + trainRatio) / factorial(max(testRatio,trainRatio));
    else
        iterations = factorial(10);
    end
end
if nargin >=8
    rng(seed);
end
trainRatio = trainRatio / gcd(trainRatio,testRatio);
testRatio = testRatio / gcd(trainRatio,testRatio);
evaluationSize = uint8(testRatio * size(images,1) / (testRatio + trainRatio));
accuracies = [];
for i=1:iterations
    [Train, Test] = crossvalind('LeaveMOut', size(images,1), evaluationSize);
    model = modelFunction(images(Train), labels(Train));
    results = testFunction(model, images(Test));
    
    comparison = (labels(Test) == results);
    accuracies = [accuracies;sum(comparison) / length(comparison)];
end
accuracy = sum(accuracies) / iterations;

end

