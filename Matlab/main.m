close all;
clear all;

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
disp('Rescaling training images for PCA.');
trainingImagesRescaled = rescaleImages(training.images, pcaScale, imX, imY);
disp('Starting training dimensionality reduction with PCA.');
[trainingEigenVectors, trainingEigenValues, trainingImMean, trainingImPCA] = applyPCA(trainingImagesRescaled, 29);

disp('Rescaling testing images for PCA.');
testingImagesRescaled = rescaleImages(testing.images, pcaScale, imX, imY);
disp('Starting testing dimensionality reduction with PCA.');
[testingEigenVectors, testingEigenValues, testingImMean, testingImPCA] = applyPCA(testingImagesRescaled, 30);

% HOG Feature Extraction
disp ('Extracting HOG Feature Vectors.');
trainingFeatureVectors = extractHogFeatures(training.images, imY, imX);
testingFeatureVectors = extractHogFeatures(testing.images, imY, imX);

%% Classification

% Binary SVM Classification
disp ('Generating binary SVM Model');
SVMModel = SVMTraining(training.images, training.labels);
binaryPredictions = SVMTesting(SVMModel, testing.images);

disp ('Calculating binary SVM Accuracy');
binaryComparison = (testing.labels==binaryPredictions);
binaryAccuracy = sum(binaryComparison)/length(binaryComparison)

% Hog SVM Classification
disp ('Calculating HOG SVM Model');
HOGSVMModel = SVMTraining(trainingFeatureVectors, training.labels);
HOGPredictions = SVMTesting(HOGSVMModel, testingFeatureVectors);

disp ('Calculating HOG SVM Accuracy');
HOGComparison = (testing.labels==HOGPredictions);
HOGAccuracy = sum(HOGComparison)/length(HOGComparison)

% PCA SVM Classification
disp ('Calculating PCA SVM Model')
trainingEigenVectors = trainingEigenVectors';
PCASVMModel = SVMTraining(trainingEigenVectors, training.labels);
testingEigenVectors = testingEigenVectors';
PCAPredictions = SVMTesting(PCASVMModel, testingEigenVectors);

disp ('Calculating PCA SVM Accuracy');
PCAComparison = (testing.labels==PCAPredictions);
PCAAccuracy = sum(PCAComparison)/length(PCAComparison)