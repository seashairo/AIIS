function [ results, confidences ] = CompositeModelTesting( models, images )

    results = [];
    confidences = zeros(size(images,1),1);
    
    testingFunctions = {@AdaboostTesting, @SVMTesting};
    weights = [0.74433, .726667];
    
    %This function first runs each individual classifier model packaged into
    %the classifier, storing the results.
    for i=1:size(testingFunctions,1)
        [result,confidence] = testing(models{i}, images, testingFunctions{i});
        
        %This adjusts the results value to be either positive or negative,
        %for usage with the confidence value.
        result(result==0) = -1;
        
        %This value adjusts the confidence values for a given output based
        %on the result, making it positive if a positive match and negative
        %if a negative match, and then adjusts the value based on both the
        %weight of the model just tested divided by the sum of the weight
        %of the whole set.
        confidence = ((result .* confidence) * weights(i)) / sum(weights);
        
        %These values are then added to the set of confidences.
        confidences = confidences + confidence;
    end
    
    confidence = zeros(size(images,1),1);
    results=zeros(size(images,1),1);
    
    %This iterates through each result and confidence value, setting them 
    %to positive as needed.
    for i=1:size(images,1)
        %If the confidence value is greater than zero, indicating a
        %positive match, as noted above, the result is set to 1. Otherwise,
        %as results defaults to zero, nothing is need to adjust the results
        %value for this position. As the confidences were set to be less
        %than zero if a negative match, it is then converted to a positive
        %value, as we deal with positives when handling the confidences for
        %non-maxima suppression
        if confidences(i)>0
            results(i) = 1;
        else
            confidences(i) = abs(confidences(i));
        end
    end

end

function [ results, confidence ] = testing( model, images, testingFunction )
[results, confidence] = testingFunction(model, images);

end