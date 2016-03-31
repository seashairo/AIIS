function [vidframes] = loadVideoFrames(path)
% Loads images from given path and returns them.
    imageDir = dir(path);
    % Required to avoid filling empty frames with Zero Matrix's
    currentFrame = 1;
    for ii=1 : size(imageDir)
        file = imageDir(ii);
        
        if file.isdir == 1
            continue
        end  
        im = imread(strcat(path, file.name));
        vidframes(:,:,:,currentFrame) = im;
        currentFrame = currentFrame + 1;
    end
end

