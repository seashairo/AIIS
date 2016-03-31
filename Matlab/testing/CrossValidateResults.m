function [ ] = CrossValidateResults( images, HOGimages, PCAimages, labels )
%This function performs similar behaviour to testingResults, but does so
%with crossvalidation instead of standard testing.

disp(strcat(char(10),'Starting Cross Validation'));


totalMislabelled = [];

training = @blindTraining;
testing = @blindTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Blind', training, testing);

training = @NNTraining;
testing = @NNTesting;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'NN', training, testing);
totalMislabelled = mislabelled;

training = @NNTraining;
testing = @KNN9Testing;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'KNN9', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

training = @NNTraining;
testing = @FuzzyKNN9Testing;
mislabelled = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Fuzzy KNN9', training, testing);
totalMislabelled = twoSetIntersection(totalMislabelled,mislabelled);

training = @NNTraining;
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

training = @CompositeModelTraining;
testing = @CompositeModelTesting;
CrossValidateIterateCall(images, HOGimages, PCAimages, labels, 'Composite (Adaboost + SVM)', training, testing);

%This outputs what images every single classifier failed to correctly label
if size(totalMislabelled,1) > 0
  disp(strcat('All classifiers consistently mislabelled :', mat2str(totalMislabelled)));
end
end

function [totalMislabel] = CrossValidateIterateCall(images, HOGimages, PCAimages, labels, classifierName, training, testing)
%This runs the chosen classifier with Raw images, PCA images and HOG
%images, and then outputs various useful metrics.

iterations = 20;
maxRatio = 5;
seed = 0;
totalMislabel = [];

 [accuracy,best, ~, consistentlyMislabelled, trainTime, testTime] = CrossValidationIterations(images,labels,...
    training,testing,maxRatio,iterations,seed);
disp(strcat(classifierName,' Raw Cross Validation took',char(20), num2str(trainTime + testTime), ' seconds on average'));
   disp(strcat(classifierName,' Raw Cross Validation took',char(20), num2str(trainTime), ' seconds to train on average'));
   disp(strcat(classifierName,' Raw Cross Validation took',char(20), num2str(testTime), ' seconds to test on average'));
 disp(strcat(classifierName,' Raw Cross Validation - Accuracy =',char(20) ,num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' Raw Cross Validation consistently mislabelled elements',char(20), mat2str(consistentlyMislabelled), ' of the set.'));
 disp(strcat(classifierName,' Raw found to be most accurate with',char(20), num2str(best),':1 training:testing ratio'));
   totalMislabel = consistentlyMislabelled;
 
  [accuracy,best, ~, consistentlyMislabelled, trainTime, testTime] = CrossValidationIterations(HOGimages,labels,...
    training,testing,maxRatio,iterations,seed);
disp(strcat(classifierName,' HOG Cross Validation took ',char(20), num2str(trainTime + testTime), ' seconds on average'));
  disp(strcat(classifierName,' HOG Cross Validation took ',char(20), num2str(trainTime), ' seconds to train on average'));
   disp(strcat(classifierName,' HOG Cross Validation took ',char(20), num2str(testTime), ' seconds to test on average'));
 disp(strcat(classifierName,' HOG Cross Validation - Accuracy =  ',char(20), num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' HOG Cross Validation consistently mislabelled elements',char(20), mat2str(consistentlyMislabelled), ' of the set.'));
 disp(strcat(classifierName,' HOG found to be most accurate with',char(20), num2str(best),':1 training:testing ratio'));
 totalMislabel = twoSetIntersection(totalMislabel, consistentlyMislabelled);
  
  [accuracy,best, ~, consistentlyMislabelled, trainTime, testTime] = CrossValidationIterations(PCAimages,labels,...
    training,testing,maxRatio,iterations,seed);
disp(strcat(classifierName,' PCA Cross Validation took',char(20), num2str(trainTime + testTime), ' seconds on average'));
  disp(strcat(classifierName,' PCA Cross Validation took ',char(20), num2str(trainTime), ' seconds to train on average'));
   disp(strcat(classifierName,' PCA Cross Validation took ',char(20), num2str(testTime), ' seconds to test on average'));
 disp(strcat(classifierName,' PCA Cross Validation - Accuracy =  ',char(20), num2str(100*accuracy),'%'));
  disp(strcat(classifierName,' PCA Cross Validation consistently mislabelled elements',char(20), mat2str(consistentlyMislabelled), ' of the set.'));
  disp(strcat(classifierName,' PCA found to be most accurate with',char(20), num2str(best),':1 training:testing ratio'));
    totalMislabel = twoSetIntersection(consistentlyMislabelled,totalMislabel);
    
  disp(strcat(classifierName,' Cross Validation consistently mislabelled elements',char(20), mat2str(totalMislabel), ' of the set.'));
  disp(char(10));
  end

%The built in intersection method for Matlab disapproves of intersecting
%single or no values with a set. Thus, this algorithm handles this
%logic where needed.
function [intersection] = twoSetIntersection(A,B)
    tolerance = 1e-5;
    if size(A,1) > 1 && size(B,1) > 1
        B = intersect(A,B);
    elseif size(A,1) == 0 || size(B,1)== 0
        B = [];
    elseif (size(A,1) == 1) && (size(A,1) == 1)
        if (A==B)
            B = B;
        else
            B = [];
        end
    elseif size(B,1) > 1
        if any(abs(B-A)<tolerance) 
            B = A;
        else
            B = [];
        end
    elseif size(A,1) > 1
        if any(abs(B-A)<tolerance)
            B = B;        
        else
            B = [];
        end
    else
        B = [];
    end
    intersection = B;
end