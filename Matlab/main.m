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
figure('Position', [100, 100, 960, 800]);
for ii = 1 : min(size(negativeTraining, 1), 100)
    subplot_tight(5, 10, ii);
    im = negativeTraining(ii, :);
    im = reshape(im, [imY, imX]);
    imshow(im);
end

figure('Position', [100, 100, 960, 800]);
for ii = 1 : min(size(positiveTraining, 1), 100)
    subplot_tight(5, 10, ii);
    im = positiveTraining(ii, :);
    im = reshape(im, [imY, imX]);
    imshow(im);
end
clear ii im;

colormap(gray);

%% Feature Extraction Coming Soon (tm)
% rawPixelBased uses training.images
% dimensionality reduction uses PCA - WARNING: SLOWER THAN A CUP OF DIRT
disp('Rescaling images for PCA.');
imagesRescaled = rescaleImages(training.images, pcaScale, imX, imY);
disp('Starting dimensionality reduction with PCA.');
[eigenVectors, eigenValues, imMean, imPCA] = applyPCA(imagesRescaled);

%% Classification Coming Soon (tm)