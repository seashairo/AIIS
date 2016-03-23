%% Initialisation
close all;
clear all;
addpath('utils');
addpath('featureExtraction');
addpath('classification');
addpath('testing');

%% Global parameters used throughout project.
% Sampling rate for loading images.
sampling = 50;
% Image dimensions
imX = 96;
imY = 160;
% PCA parameters
pcaScale = 0.5;
pcaNumDimensions = 10;

%% Load training and testing data.
disp('Loading training and testing images.');
[training testing] = loadTrainingTestingImages(1, sampling);
negativeTraining = training.images(training.labels == -1, :);
positiveTraining = training.images(training.labels == 1, :);
negativeTesting = testing.images(testing.labels == -1, :);
positiveTesting = testing.images(testing.labels == 1, :);
disp('Loaded training and testing images.');

%% Load video data.
disp('Loading video data.');
video = loadVideoFrames('pedestrian/');
disp('Loaded video data.');

%% Show some images from training data.
%{
figure('Name','Negative Images','NumberTitle','Off','Position', [100, 100, 960, 800]);
for ii = 1 : min(size(negativeTraining, 1), 100)
    subplot_tight(5, 10, ii);
    im = negativeTraining(ii, :);
    im = reshape(im, [imY, imX]);
    imshow(im);
end

figure('Name','Positive Images','NumberTitle','Off','Position', [100, 100, 960, 800]);
for ii = 1 : min(size(positiveTraining, 1), 100)
    subplot_tight(5, 10, ii);
    im = positiveTraining(ii, :);
    im = reshape(im, [imY, imX]);
    imshow(im);
end
clear ii im;

colormap(gray);
%}

%% Feature Extraction.
% Raw pixel based uses training.images
% Dimensionality reduction uses PCA - WARNING: SLOWER THAN A CUP OF DIRT
disp('Rescaling images for PCA.');
trainingImagesRescaled = rescaleImages(training.images, pcaScale, imX, imY);
testingImagesRescaled = rescaleImages(testing.images, pcaScale, imX, imY);
disp('Starting dimensionality reduction with PCA.');
[eigenVectors, eEigenValues, imMean, pcaTrainingImages] = applyPCA(trainingImagesRescaled, 29);
% Apply PCA to testing images separately.
pcaTestImages = [];
for i = 1 : size(testingImagesRescaled, 1)
    pcaTestImages = [pcaTestImages; ((testingImagesRescaled(i, :) - imMean) * eigenVectors)];
end

% HOG Feature Extraction
disp ('Extracting HOG Feature Vectors.');
trainingFeatureVectors = extractHogFeatures(training.images, imY, imX);
testingFeatureVectors = extractHogFeatures(testing.images, imY, imX);

%% Classification
% NN Classification
[accuracy, results] = trainAndTest(training.images, training.labels, ...
    @NNTraining, testing.images, testing.labels, @NNTesting);
disp(strcat('NN Raw Images - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(trainingFeatureVectors, training.labels, ...
    @NNTraining,  testingFeatureVectors, testing.labels, @NNTesting);
disp(strcat('NN HOG - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @NNTraining, pcaTestImages, testing.labels, @NNTesting);
disp(strcat('NN PCA - Accuracy =  ', num2str(accuracy)));

% KNN Classification
[accuracy, results] = trainAndTest(training.images, training.labels, ...
    @NNTraining, testing.images, testing.labels, @KNN3Testing);
disp(strcat('KNN3 Raw Images - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(trainingFeatureVectors, training.labels, ...
    @NNTraining,  testingFeatureVectors, testing.labels, @KNN3Testing);
disp(strcat('KNN3 HOG - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @NNTraining, pcaTestImages, testing.labels, @KNN3Testing);
disp(strcat('KNN3 PCA - Accuracy =  ', num2str(accuracy)));

[accuracy, results] = trainAndTest(training.images, training.labels, ...
    @NNTraining, testing.images, testing.labels, @KNN9Testing);
disp(strcat('KNN9 Raw Images - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(trainingFeatureVectors, training.labels, ...
    @NNTraining,  testingFeatureVectors, testing.labels, @KNN9Testing);
disp(strcat('KNN9 HOG - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @NNTraining, pcaTestImages, testing.labels, @KNN9Testing);
disp(strcat('KNN9 PCA - Accuracy =  ', num2str(accuracy)));

% SVM Classification
[accuracy, results] = trainAndTest(training.images, training.labels, ...
    @SVMTraining, testing.images, testing.labels, @SVMTesting);
disp(strcat('SVM Raw Images - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(trainingFeatureVectors, training.labels, ...
    @SVMTraining,  testingFeatureVectors, testing.labels, @SVMTesting);
disp(strcat('SVM HOG - Accuracy =  ', num2str(accuracy)));
[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @SVMTraining, pcaTestImages, testing.labels, @SVMTesting);
rr = evaluateResults(testing.labels, results);
displayResults(testing.images, testing.labels, results, imX, imY);
disp(strcat('SVM PCA - Accuracy =  ', num2str(accuracy)));

implay(video);
