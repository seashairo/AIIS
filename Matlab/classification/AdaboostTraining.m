function [modelAda] = AdaboostTraining(images,labels,learningCycles)
    %The Adaboost binary classification model rates things from -1 to 1,
    %while we use values of 0 and 1. Thus, conversion of zero values to -1
    labels(labels<=0) = -1;
    
    %Higher values of learningCycles = more computation time but a
    %generally more precise model
    if nargin<3 || learningCycles < 1
        learningCycles = 100;
    end
    
    %Develop an ensable with the AdaBoostM1 classifier, where "Tree" is the
    %weak classifier type we use.
    modelAda = fitensemble(images,labels,'AdaBoostM1',learningCycles,'Tree');
end