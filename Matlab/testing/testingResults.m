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
rr = evaluateResults(testingLabels,results);
displayEvaluation(rr,strcat(classifierName,' Raw',char(20)));
tic
[accuracy, results] = trainAndTest(trainingHOGimages, trainingLabels, ...
    modelFunction, testingHOGimages, testingLabels, testingFunction);
disp(strcat(classifierName,' HOG Images - Accuracy =  ', num2str(accuracy)));
disp(strcat(classifierName,' HOG Images - Time =  ', num2str(toc)));
rr = evaluateResults(testingLabels,results);
displayEvaluation(rr,strcat(classifierName,' HOG',char(20)));
tic
[accuracy, results] = trainAndTest(trainingPCAimages, trainingLabels, ...
    modelFunction, testingPCAimages, testingLabels, testingFunction);
disp(strcat(classifierName,' PCA Images - Accuracy =  ', num2str(accuracy)));
disp(strcat(classifierName,' PCA Images - Time =  ', num2str(toc)));
rr = evaluateResults(testingLabels,results);
displayEvaluation(rr,strcat(classifierName,' PCA',char(20)));
end

function [] = displayEvaluation(ff,prefix)
disp(strcat(prefix,'Type 1 Error = ',char(20),num2str(ff.fp)));
disp(strcat(prefix,'Type 2 error =  ',char(20),num2str(ff.fn)));
disp(strcat(prefix,'Precision =  ',char(20),num2str(ff.precision)));
disp(strcat(prefix,'Sensitivity (recall) =  ',char(20),num2str(ff.recall)));
disp(strcat(prefix,'Specificity =  ',char(20),num2str(ff.specificity)));
disp(strcat(prefix,'False Positive Rate = ',char(20),num2str(ff.far)));
disp(strcat(prefix,'F-Measure = ' ,char(20),num2str(ff.f1)));
end
