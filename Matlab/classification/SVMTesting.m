function [prediction] = SVMTesting2(model,images)
%SVMTESTING2 Summary of this function goes here
%   Detailed explanation goes here
    prediction = predict(model, images);
end


