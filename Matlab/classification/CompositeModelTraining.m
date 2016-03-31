function [ models ] = CompositeModelTraining( images,labels )
%This function trains multiple models sequentially, for later usage in
%creating a confidence based set of results, and stores the results as a
%set of model variables.

trainingFunctions = {@AdaboostTraining, @SVMTraining};

for i=1:size(trainingFunctions,1)
    models{i} = training(images, labels, trainingFunctions{i});
end

end

function [ model ] = training( images,labels, trainingFunction )
model = trainingFunction(images, labels);

end