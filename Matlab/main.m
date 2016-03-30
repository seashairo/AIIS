%% Initialisation
close all;
clear all;
addpath('utils');
addpath('detection');
addpath('featureExtraction');
addpath('classification');
addpath('testing');

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
%Single run with 50:50 split
trainAndTestResults( training.images, testing.images, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, training.labels, testing.labels )

[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @SVMTraining, pcaTestImages, testing.labels, @SVMTesting);
rr = evaluateResults(testing.labels, results);
displayResults(testing.images, testing.labels, results, imX, imY);

    hold on;

%Cross Validation
CrossValidateResults([training.images;testing.images], [trainingFeatureVectors;testingFeatureVectors],[pcaTrainingImages;pcaTestImages],[training.labels;testing.labels]);

[accuracry, results, model] = trainAndTest(trainingFeatureVectors, training.labels, @SVMTraining, testingFeatureVectors, testing.labels, @SVMTesting);
objects = [];
for ii = 1 : size(video,4)
    tic
    disp(strcat('Processing Frame  ', num2str(ii)));
    % search each frame with an window size of 1.5*imY and 1.5*imX;
    [video(:,:,:,ii), tempobjects] = objectDetection(video(:,:,:,ii), model, 240, 144, 0.7);
    objects = [objects; tempobjects];
    [video(:,:,:,ii), tempobjects] = objectDetection(video(:,:,:,ii), model, 160, 96, 0.7);
    objects = [objects; tempobjects];
    [video(:,:,:,ii), tempobjects] = objectDetection(video(:,:,:,ii), model, 80, 46, 0.7);
    objects = [objects; tempobjects];
    % apply NMS if we have objects and draw the boxes.
    if isempty(objects) == 0
        objects = simpleNMS(objects, 0.3);
    end

    for jj = 1 : size(objects,1) 
        video(:,:,:,ii) = addBoxToImage(video(:,:,:,ii), objects(jj,1), objects(jj,2), objects(jj,5), objects(jj,4));
    end
    toc
end



implay(video, 5);

%vidObj = VideoWriter('SlidingWindow.avi')
%open(vidObj)
%writeVideo(vidObj,video);
%close(vidObj)