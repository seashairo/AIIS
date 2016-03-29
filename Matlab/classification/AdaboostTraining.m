function [modelAda] = AdaboostTraining(images,labels,learningCycles)
    %The Adaboost binary classification model rates things from -1 to 1,
    %while we use values of 0 and 1. Thus, conversion of zero values to -1
    labels(labels<=0) = -1;
    
    %Higher values of learningCycles = more computation time but a
    %generally more precise model
    if nargin<3 || learningCycles < 1
        learningCycles = 50;
    end
    
    %Develop an ensemble with the AdaBoostM1 classifier, where we use a
    %decision tree as the weak classifier type
    %Note that the first learner being perfect would result in a warning
    %being thrown. The problem this error refers to is handled via the if
    %statement below, and is explained in detail there. As such, the
    %warning is suppressed.
    warning('off','stats:classreg:learning:modifier:AdaBoostM1:modify:Terminate');
    modelAda = fitensemble(images,labels,'AdaBoostM1',learningCycles,'Tree');
    
    %Owing to the way fitensemble works, if the first weak learners is
    %perfect, it will not be added to the ensemble. This is because there
    %is no error with which to adjust subsequent learners with and thus
    %subsequent learners will have nothing to do. Thus, instead, the single
    %perfect learner is sufficient. Hence, make the model that classifier
    %While this is an extreme situation and unlikely to occur, with a
    %proportionally smaller training set than testing set, it can.
    if modelAda.NTrained == 0
        modelAda = fit(ClassificationTree.template, images, labels);
    end
end