function [ eigenVectors, eigenValues, imMean, imPCA ] = applyPCA( images, numDimensions )
% Applies PCA to the passed in image set.
% Reference: PrincipalComponentAnalysis.m from practical 5.

    % Calculate mean of images.
    imMean = mean(images, 1);
    
    %Subtract the mean from each image.
    A = zeros(size(images));
    for i = 1  : size(images, 1)
        A(i, :) = images(i, :) - imMean;
    end
    
    % Calculate covariance of samples-mean
    aCovariance = cov(A);
    
    % Get the eigenvectors/eigenvalues
    [vectors, values] = eig(aCovariance);
    eigenValues = diag(values);
    eigenValues = eigenValues(end:-1:1);
    eigenVectors = fliplr(vectors);

    % If no number of dimensions is provided, calculate one which will 
    % cover 95% variance.
    if nargin < 2
        eigenSum = cumsum(eigenValues);
        eigenSum = eigenSum / eigenSum(end);
        index = find(eigenSum >= 0.95);
        numDimensions = index(1);
    end
    
    % Return vectors/values within given number of dimensions.
    eigenVectors = eigenVectors(:, 1:numDimensions);
    eigenValues = eigenValues(1:numDimensions);
    imPCA = A * eigenVectors;
end

