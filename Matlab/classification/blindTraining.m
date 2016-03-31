function [ model ] = blindTraining( images,labels )
%This classifier exists purely to serve as a baseline system. It assigns a
%classification of "not a person" to literally everything.
model.images = ones(size(images,1));
model.labels = ones(size(labels,1));

end

