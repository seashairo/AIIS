function [ prediction, confidence ] = AdaboostTesting( model, testImages  )
    %Use the generated adaboost model to predict the classification of
    %every image in the test set, returrning the list of predicted labels
    %and the model's confidence in said labels
    [prediction, confidence] = predict(model, testImages);
    
    %The model predicts values of -1 or 1, while we use values of 0 or 1.
    %Hence, convert values of -1 to 0.
    prediction(prediction<0) = 0;
    
    %Transpose the generated confidence array to use the max function to
    %get the highest confidence value for each pair of confidence values,
    %then transpose back to get it in row major form.
    confidence = max(confidence.').';
end

