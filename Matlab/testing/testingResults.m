function [] = testingResults( trainingImages,testingImages, ...
                            trainingHOGimages, testingHOGimages,...
                            trainingPCAimages,testingPCAimages, ...
                            trainingLabels, testingLabels, ...
                            modelFunction, testingFunction, classifierName)
%This function takes in the various training and testing image sets, as
%well as the associated labels, and executes the chosen classification
%technique using each paired set (raw training with raw testing, HOG
%training with HOG testing, PCA training with PCA testing)
tic
[accuracy, results] = trainAndTest(trainingImages, trainingLabels, ...
    modelFunction, testingImages, testingLabels, testingFunction);
disp(strcat(classifierName,' Raw Images - Accuracy =  ', num2str(accuracy)));
disp(strcat(classifierName,' Raw Images - Time =  ', num2str(toc)));
tic
[accuracy, results] = trainAndTest(trainingHOGimages, trainingLabels, ...
    modelFunction, testingHOGimages, testingLabels, testingFunction);
disp(strcat(classifierName,' HOG Images - Accuracy =  ', num2str(accuracy)));
disp(strcat(classifierName,' HOG Images - Time =  ', num2str(toc)));
tic
[accuracy, results] = trainAndTest(trainingPCAimages, trainingLabels, ...
    modelFunction, testingPCAimages, testingLabels, testingFunction);
disp(strcat(classifierName,' PCA Images - Accuracy =  ', num2str(accuracy)));
disp(strcat(classifierName,' PCA Images - Time =  ', num2str(toc)));

end
