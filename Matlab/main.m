close all;
clear all;

%% Global parameters used throughout project.
% Image dimensions
imX = 96;
imY = 160;

%% Load training and testing data.
[training testing] = loadTrainingTestingImages();
negativeTraining = training.images(training.labels == -1, :);
positiveTraining = training.images(training.labels == 1, :);
negativeTesting = testing.images(testing.labels == -1, :);
positiveTesting = testing.images(testing.labels == 1, :);

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

%% Feature Extraction

%% HOG Feature Extraction
positiveFeatureVectors = extractHogFeatures(positiveTraining, imY, imX);
negativeFeatureVectors = extractHogFeatures(negativeTraining, imY, imX);

%% Classification Coming Soon (tm)