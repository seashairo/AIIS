function [ model ] = NNTraining( images, labels )
% Creates a model for testing NN.
% Reference: Practical 3
    model = struct('samples', images, 'labels', labels);
end

