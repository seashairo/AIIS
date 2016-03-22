function [model] = SVMTraining(images, labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    model = fitcsvm(images,labels)
end
