function [  ] = trainAndTestResults( trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Blind Classification
trainingFunction = @blindTraining;
testingFunction = @blindTesting;
classificationName = 'Blind';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

% NN Classification
trainingFunction = @NNTraining;
testingFunction = @NNTesting;
classificationName = 'NN';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);
       
% KNN Classification
trainingFunction = @NNTraining;
testingFunction = @KNN3Testing;
classificationName = 'KNN3';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

trainingFunction = @NNTraining;
testingFunction = @KNN9Testing;
classificationName = 'KNN9';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

%Fuzzy KNN Classification
trainingFunction = @NNTraining;
testingFunction = @FuzzyKNN9Testing;
classificationName = 'Fuzzy KNN9';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

trainingFunction = @NNTraining;
testingFunction = @FuzzyKNN9LowWeightTesting;
classificationName = 'Fuzzy Low Weight KNN9';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

trainingFunction = @NNTraining;
testingFunction = @FuzzyKNN9HighWeightTesting;
classificationName = 'Fuzzy High Weight KNN9';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

% SVM Classification
trainingFunction = @SVMTraining;
testingFunction = @SVMTesting;
classificationName = 'SVM';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

%Adaboost Classification
trainingFunction = @AdaboostTraining;
testingFunction = @AdaboostTesting;
classificationName = 'Adaboost';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

%Composite Classification
trainingFunction = @CompositeModelTraining;
testingFunction = @CompositeModelTesting;
classificationName = 'Composite Adaboost/SVM';
testingResults(trainingImages, testingImages, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, trainingLabels, testingLabels, trainingFunction,testingFunction,classificationName);

end

