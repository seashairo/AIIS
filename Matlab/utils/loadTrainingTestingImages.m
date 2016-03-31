function [training, testing] = loadTrainingTestingImages(forceRebuild, sampling)
% Loads images from the images folder into training and testing databases.
% If forceRebuild is 1, then the image db will be reconstructed using the
% given sampling rate, otherwise it will attempt to load from a .mat file.

    % If the image db already exists, load it instead of building it again.
    if forceRebuild == 0
        if exist('training.mat', 'file') == 2 && exist('testing.mat', 'file') == 2
            disp('Loading image database from .mat files.');
            load training;
            load testing;
            return;
        else
            disp('Couldn''t find training and testing databases. Rebuilding now...');
        end
    else
        disp('Building image database...');
    end
    
    
    % Get list of images.
    negativeImages = loadPreprocessedImagesFrom('images/neg/', sampling);
    positiveImages = loadPreprocessedImagesFrom('images/pos/', sampling);
    
    % Assign images to testing and training.
    [negTraining negTesting] = splitImageList(negativeImages);
    [posTraining posTesting] = splitImageList(positiveImages);
    training = struct('images', [negTraining; posTraining]);
    testing = struct('images', [negTesting; posTesting]);
    
    % Set image labels.
    training.labels = [ones(size(negTraining, 1), 1) * 0; ones(size(posTraining, 1), 1)];
    testing.labels = [ones(size(negTesting, 1), 1) * 0; ones(size(posTesting, 1), 1)];
    
    % For convenience, add struct sizes.
    training.size = size(training.labels, 1);
    testing.size = size(testing.labels, 1);
    
    save training;
    save testing;
end



function [images] = loadPreprocessedImagesFrom(path, sampling)
% Loads and preprocesses images from given path and returns them.
% Preprocessing involves converting into a doubled grayscale vector.
    imageDir = dir(path);
    images = [];
    for ii=1 : sampling : size(imageDir)
        file = imageDir(ii);
        % dir() also loads . and .. as names - those can't be read.
        if file.isdir == 1
            continue
        end

        im = imread(strcat(path, file.name));
        % Only convert to grayscale if it isn't already grayscale.
        if size(im, 3) == 1
            imGray = im;
        else
            imGray = rgb2gray(im);
        end
        
        % Convert image into a vector and double it.
        imVector = reshape(imGray, 1, size(imGray, 1), size(imGray, 2));
        imDouble = im2double(imVector);
        images = [images; imDouble];
    end
end



function [a b] = splitImageList(images)
% Takes a list of images and splits them evenly into two lists. 
    a = [];
    b = [];
    flag = 0;
    
    for ii=1 : size(images)
        if flag == 1
            a = [a; images(ii, :)];
        else
            b = [b; images(ii, :)];
        end
        flag = ~flag;
    end
end