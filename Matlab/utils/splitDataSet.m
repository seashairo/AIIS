function [ trainImages, trainLabels, testImages, testLabels, testIndices ] = splitDataSet( images, labels, trainRatio, testRatio )
%This function splits the dataset into two based on the input ratios, one
%representing the training set and one representing the testing set

%If neither ratio is passed to the function, it defaults to a 50/50 split
%If the first ratio parameter is passed to the function, and it is
%valid, the function uses that parameter for the ratio of the training set
%and defaults to a ratio of 1 for the testing set
if nargin < 4 || testRatio < 1
    if nargin < 3 || trainRatio < 1
        trainRatio = 1;
    end
    testRatio = 1;
end

%This reduces the values of trainRatio and testRatio to the minimum
%equivalent value via use of the greatest common divisor.
trainRatio = trainRatio / gcd(trainRatio,testRatio);
testRatio = testRatio / gcd(trainRatio,testRatio);

%This uses the ratios given to determine the number of results from the
%provided dataset to allocate to the testing set
testSetSize = uint8(testRatio * size(images,1) / (testRatio + trainRatio));

%This generates a random split of the dataset using the size of the 
%dataset and the desired size of the test set.
[Train, Test] = crossvalind('LeaveMOut', size(images,1), testSetSize);

trainImages = images(Train);
trainLabels = labels(Train);
testImages = images(Test);
testLabels = labels(Test);
testIndices = Test;
end

