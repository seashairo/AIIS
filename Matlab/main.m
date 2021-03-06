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
disp(strcat('Sample rate: 1 in',char(20),num2str(sampling),' images.'));
loadTestData('test.dataset');
% Image dimensions
imX = 96;
imY = 160;
% PCA parameters
pcaScale = 0.5;
pcaNumDimensions = 10;

TestCoords = loadTestData('test.dataset');

%% Load training and testing data.
disp('Loading training and testing images.');
[training testing] = loadTrainingTestingImages(1, sampling);
negativeTraining = training.images(training.labels == 0, :);
positiveTraining = training.images(training.labels == 1, :);
negativeTesting = testing.images(testing.labels == 0, :);
positiveTesting = testing.images(testing.labels == 1, :);
disp('Loaded training and testing images.');

%% Load video data.
disp('Loading video data.');
OriginalVideo = loadVideoFrames('pedestrian/');
SampleVideo = OriginalVideo;
TestVideo = OriginalVideo;
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
tic
trainingImagesRescaled = rescaleImages(training.images, pcaScale, imX, imY);
testingImagesRescaled = rescaleImages(testing.images, pcaScale, imX, imY);
disp('Starting dimensionality reduction with PCA.');
[eigenVectors, eEigenValues, imMean, pcaTrainingImages] = applyPCA(trainingImagesRescaled, 101);
% Apply PCA to testing images separately.
pcaTestImages = [];
for i = 1 : size(testingImagesRescaled, 1)
    pcaTestImages = [pcaTestImages; ((testingImagesRescaled(i, :) - imMean) * eigenVectors)];
end
disp(strcat('Dimensionality reduction with PCA took',char(20),num2str(toc),' seconds to complete.'));


% HOG Feature Extraction
disp ('Extracting HOG Feature Vectors.');
tic
trainingFeatureVectors = extractHogFeatures(training.images, imY, imX);
testingFeatureVectors = extractHogFeatures(testing.images, imY, imX);
disp(strcat('Extracting HOG Feature Vectors took',char(20),num2str(toc),' seconds to complete.'));

%% Classification
%Single run with 50:50 split
%trainAndTestResults( training.images, testing.images, trainingFeatureVectors, testingFeatureVectors, pcaTrainingImages, pcaTestImages, training.labels, testing.labels )

%{
[accuracy, results] = trainAndTest(pcaTrainingImages, training.labels, ...
    @SVMTraining, pcaTestImages, testing.labels, @SVMTesting);
rr = evaluateResults(testing.labels, results);
displayResults(testing.images, testing.labels, results, imX, imY);

    hold on;
%}

%Cross Validation
%CrossValidateResults([training.images;testing.images], [trainingFeatureVectors;testingFeatureVectors],[pcaTrainingImages;pcaTestImages],[training.labels;testing.labels]);

[ model ] = SVMTraining(trainingFeatureVectors, training.labels);

% Roc Curve for SVM HOG Example
%[ Prediction, confidence ] = SVMTesting(model,testingFeatureVectors);
%rocCurves(Prediction, confidence, ' SVM HOG');

% Perform Multi Scale object detection.
for ii = 1 : size(SampleVideo,4)
    tic
    objects = [];
    disp(strcat('Processing Frame  ', num2str(ii)));
    % search each frame with an window size of 1.5*imY and 1.5*imX;
    [SampleVideo(:,:,:,ii), tempobjects] = objectDetection(SampleVideo(:,:,:,ii), model, 240, 144, 0.7);
    objects = [objects; tempobjects];
    % search each frame with an window size of imY and imX;
    [SampleVideo(:,:,:,ii), tempobjects] = objectDetection(SampleVideo(:,:,:,ii), model, 160, 96, 0.7);
    objects = [objects; tempobjects];
    % search each frame with an window size of 0.5*imY and 0.5*imX;
    [SampleVideo(:,:,:,ii), tempobjects] = objectDetection(SampleVideo(:,:,:,ii), model, 80, 48, 0.7);
    objects = [objects; tempobjects];
    % apply NMS if we have objects and draw the boxes.
    if isempty(objects) == 0
        objects = simpleNMS(objects, 0.3);
    end

    for jj = 1 : size(objects,1) 
        SampleVideo(:,:,:,ii) = addBoxToImage(SampleVideo(:,:,:,ii), objects(jj,1), objects(jj,2), objects(jj,5), objects(jj,4), uint8([255 0 0]));
    end
    toc
end

% Add Bounding Boxes to SampleVideo.
for ii = 1 : size(SampleVideo,4)
     tic
     disp(strcat('Processing Frame  ', num2str(ii)));
     jj = ii;
     for kk = 1 : TestCoords(jj,1)
         index = kk*5;
         TestVideo(:,:,:,ii) = addBoxToImage(TestVideo(:,:,:,ii), TestCoords(jj,index-3), TestCoords(jj,index-2), TestCoords(jj,index-1), TestCoords(jj,index), uint8([255 0 0]));
     end
     toc
end
 
% Display Test video and One generated by this program.
implay(SampleVideo, 5);
implay(TestVideo, 5);

% Write Videos to disk.
CreateVideoFile('OrginalVideo.avi',OriginalVideo,5);
CreateVideoFile('SampleVideo.avi',SampleVideo,5);
CreateVideoFile('TestVideo.avi',TestVideo,5);
