function [model] = SVMTraining2(images, labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    model = fitcsvm(images,labels)
end
