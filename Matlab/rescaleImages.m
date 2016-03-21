function [ imagesRescaled ] = rescaleImages( images, scale, imX, imY )
% Takes a matrix of image vectors and resizes them to [scale].
% Used in the PCA function to reduce computation time.

    imagesRescaled = [];
    for ii=1 : size(images, 1)
        im = images(ii, :);
        im = reshape(im, [imY, imX]);
        im = imresize(im, scale);
        im = reshape(im, 1, size(im, 1) * size(im, 2));
        imagesRescaled = [imagesRescaled; im];
    end

end

