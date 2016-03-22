function [vidframes] = loadVideoFrames(path)
% Loads images from given path and returns them.
    imageDir = dir(path);
    for ii=1 : size(imageDir)
        file = imageDir(ii);
        
        if file.isdir == 1
            continue
        end  
        im = imread(strcat(path, file.name));
        vidframes(:,:,:,ii) = im;
    end
end

