function [ accuracy, mostAccRatio, maxAccuracy, consistentlyMislabelled, avgTrainingTime, avgTestingTime] = CrossValidationIterations( images, labels, modelFunction, testFunction, maxTrainRatio, iterations, seed )
%This function iterates through CrossValidation with a number of
%segmentations of the data set. Each iteration segments the data with a
%different ratio of trainRatio to testRatio, with testRatio being fixed and
%trainRatio varying from 1 up to maxTrainRatio.

%This ensures at least one ratio is tested, that of a 1:1 split.
    if maxTrainRatio < 1
        maxTrainRatio = 1;
    end
    
    accuracies = [];
    avgTrainingTime = [];
    avgTestingTime = [];
    
    consistentlyMislabelled = zeros(size(images,1));
    for i=1:maxTrainRatio
        % If a seed is provided, pass it to the CrossValidation function.
        % Otherwise, perform an unseeded iteration. This allows for
        % consistency in produced results if desired.
        if nargin == 7
            [accuracy, misLabelled, trainingTime, testingTime] = CrossValidation(images, labels, modelFunction, testFunction, i, 1, iterations, seed);
        else
            [accuracy, misLabelled, trainingTime, testingTime] = CrossValidation(images, labels, modelFunction, testFunction, i, 1, iterations);
        end
        avgTrainingTime = [avgTrainingTime;trainingTime];
        avgTestingTime = [avgTestingTime;testingTime];
        %This calculates which images every instance of the chosen
        %classifier incorrectly predicted.
        for j=1:size(misLabelled,1)
            if misLabelled(j) == -1 || consistentlyMislabelled(j) == -1
                consistentlyMislabelled(j) = -1;
            else
                consistentlyMislabelled(j) = consistentlyMislabelled(j) + misLabelled(j);
            end
        end
        accuracies = [accuracies;accuracy];
    end
    %This returns the average accuracy value of the tested iterations
    accuracy = sum(accuracies) / maxTrainRatio;
    
    %This returns the testratio that produced the highest accuracy result
    [maxAccuracy,mostAccRatio] = max(accuracies);
    
    avgTrainingTime = mean(avgTrainingTime);
    avgTestingTime = mean(avgTestingTime);
    
    %If one cycle incorrectly lablelled an image, that may just be down to
    %chance. If two cycles incorrectly labelled an image, that may just be
    %coincidence. If any more incorrectly labelled it, the classifier is
    %consistently messing up with the given image.
    consistentlyMislabelled(consistentlyMislabelled<=2) = 0;
   consistentlyMislabelled = find(consistentlyMislabelled);
end

