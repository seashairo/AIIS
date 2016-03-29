function [ ] = CrossValidateResults( images, HOGimages, PCAimages, labels )
%This function performs similar behaviour to testingResults, but does so
%with crossvalidation instead of standard testing.

training = @NNTraining;
testing = @NNTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'NN', training, testing);

testing = @KNN9Testing;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'KNN9', training, testing);

testing = @FuzzyKNN9Testing;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Fuzzy KNN9', training, testing);

testing = @FuzzyKNN9HighWeightTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Fuzzy KNN9 High Weight', training, testing);

training = @SVMTraining;
testing = @SVMTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'SVM', training, testing);

training = @AdaboostTraining;
testing = @AdaboostTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Adaboost', training, testing);
end

function [] = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, classifierName, training, testing)
iterations = 20;
maxRatio = 5;
seed = 0;
 [accuracy,best] = CrossValidationIterations(images,labels,...
    training,testing,maxRatio,iterations,seed);
 disp(strcat(classifierName,' Raw Cross Validation - Accuracy =  ', num2str(accuracy)));
 %disp(strcat(classifierName,'found to be most accurate with   ', num2str(best),':1 test:training ratio'));
 
  [accuracy,best] = CrossValidationIterations(HOGimages,labels,...
    training,testing,maxRatio,iterations,seed);
 disp(strcat(classifierName,' HOG Cross Validation - Accuracy =  ', num2str(accuracy)));
 %disp(strcat(classifierName,'found to be most accurate with   ', num2str(best),':1 test:training ratio'));
 
  [accuracy,best] = CrossValidationIterations(PCAimages,labels,...
    training,testing,maxRatio,iterations,seed);
 disp(strcat(classifierName,' PCA Cross Validation - Accuracy =  ', num2str(accuracy)));
  %disp(strcat(classifierName,'found to be most accurate with   ', num2str(best),':1 test:training ratio'));
end