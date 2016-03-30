function [ ] = CrossValidateResults( images, HOGimages, PCAimages, labels )
%This function performs similar behaviour to testingResults, but does so
%with crossvalidation instead of standard testing.

totalMislabelled = [];

training = @NNTraining;
testing = @NNTesting;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'NN', training, testing);
totalMislabelled = mislabelled;

testing = @KNN9Testing;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'KNN9', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

testing = @FuzzyKNN9Testing;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Fuzzy KNN9', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

testing = @FuzzyKNN9HighWeightTesting;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Fuzzy KNN9 High Weight', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

training = @SVMTraining;
testing = @SVMTesting;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'SVM', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

training = @AdaboostTraining;
testing = @AdaboostTesting;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Adaboost', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

%This outputs what images every single classifier failed to correctly label
if size(totalMislabelled,1) > 0
  disp(strcat('All classifiers consistently mislabelled :', mat2str(totalMislabelled)));
end
end

function [totalMislabel] = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, classifierName, training, testing)
iterations = 20;
maxRatio = 5;
seed = 0;
totalMislabel = [];
tic
 [accuracy,best, ~, consistentlyMislabelled] = CrossValidationIterations(images,labels,...
    training,testing,maxRatio,iterations,seed);
   disp(strcat(classifierName,' Raw Cross Validation took =  ', num2str(toc), ' seconds'));
 disp(strcat(classifierName,' Raw Cross Validation - Accuracy =  ', num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' Raw Cross Validation consistently mislabelled ', mat2str(consistentlyMislabelled), ' of the set.'));
  totalMislabel = consistentlyMislabelled;
 %disp(strcat(classifierName,' Raw found to be most accurate with   ', num2str(best),':1 training:testing ratio'));
 
 tic
  [accuracy,best, ~, consistentlyMislabelled] = CrossValidationIterations(HOGimages,labels,...
    training,testing,maxRatio,iterations,seed);
   disp(strcat(classifierName,' HOG Cross Validation took =  ', num2str(toc), ' seconds'));
 disp(strcat(classifierName,' HOG Cross Validation - Accuracy =  ', num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' HOG Cross Validation consistently mislabelled ', mat2str(consistentlyMislabelled), ' of the set.'));
 %disp(strcat(classifierName,' HOG found to be most accurate with   ', num2str(best),':1 training:testing ratio'));
 totalMislabel = twoSetIntersection(totalMislabel, consistentlyMislabelled);
  
 tic
  [accuracy,best, ~, consistentlyMislabelled] = CrossValidationIterations(PCAimages,labels,...
    training,testing,maxRatio,iterations,seed);
   disp(strcat(classifierName,' PCA Cross Validation took =  ', num2str(toc), ' seconds'));
 disp(strcat(classifierName,' PCA Cross Validation - Accuracy =  ', num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' PCA Cross Validation consistently mislabelled ', mat2str(consistentlyMislabelled), ' of the set.'));
    totalMislabel = twoSetIntersection(consistentlyMislabelled,totalMislabel);
    
  disp(strcat(classifierName,' Cross Validation consistently mislabelled ', mat2str(totalMislabel), ' of the set.'));
  
  %disp(strcat(classifierName,'PCA found to be most accurate with ', num2str(best),':1 training:testing ratio'));
end

%Matlab does not understand how intersection between a set and a single
%value works, hence, a custom method to perform this behaviour when needed.
function [intersection] = twoSetIntersection(A,B)
    if size(A,1) > 1 && size(B,1) > 1
        B = intersect(A,B);
    else
        if size(B,1) > 1
            if any(B == A) 
                 B = A;
            else
                B = [];
            end
        else
            if size(A) > 1
                if ~any(A == B) 
                    B = [];
                end
            else
                if A ~= B
                    B = []; 
                end
            end
        end
    end
    intersection = B;
end