%% Initialisation
close all;
clear all;
addpath('utils');
addpath('featureExtraction');
addpath('classification');

%% Global parameters used throughout project.
% Sampling rate for loading images.
sampling = 10;
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

%% Show some images from training data.
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

%% Feature Extraction Coming Soon (tm)
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
disp('NN Raw Images');
disp(trainAndTest(training.images, training.labels, @NNTraining, testing.images, testing.labels, @NNTesting));
disp('NN HOG');
disp(trainAndTest(trainingFeatureVectors, training.labels, @NNTraining, testingFeatureVectors, testing.labels, @NNTesting));
disp('NN PCA')
disp(trainAndTest(pcaTrainingImages, training.labels, @NNTraining, pcaTestImages, testing.labels, @NNTesting));

% KNN Classification
disp('KNN3 Raw Images');
disp(trainAndTest(training.images, training.labels, @NNTraining, testing.images, testing.labels, @KNN3Testing));
disp('KNN3 HOG');
disp(trainAndTest(trainingFeatureVectors, training.labels, @NNTraining, testingFeatureVectors, testing.labels, @KNN3Testing));
disp('KNN3 PCA')
disp(trainAndTest(pcaTrainingImages, training.labels, @NNTraining, pcaTestImages, testing.labels, @KNN3Testing));
disp('KNN9 Raw Images');
disp(trainAndTest(training.images, training.labels, @NNTraining, testing.images, testing.labels, @KNN9Testing));
disp('KNN9 HOG');
disp(trainAndTest(trainingFeatureVectors, training.labels, @NNTraining, testingFeatureVectors, testing.labels, @KNN9Testing));
disp('KNN9 PCA')
disp(trainAndTest(pcaTrainingImages, training.labels, @NNTraining, pcaTestImages, testing.labels, @KNN9Testing));

% SVM Classification
disp('SVM Raw Images');
disp(trainAndTest(training.images, training.labels, @SVMTraining, testing.images, testing.labels, @SVMTesting));
disp('SVM HOG');
disp(trainAndTest(trainingFeatureVectors, training.labels, @SVMTraining, testingFeatureVectors, testing.labels, @SVMTesting));
disp('SVM PCA')
disp(trainAndTest(pcaTrainingImages, training.labels, @SVMTraining, pcaTestImages, testing.labels, @SVMTesting));