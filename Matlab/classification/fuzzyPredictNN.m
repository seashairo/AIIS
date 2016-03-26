function [ prediction, confidence ] = fuzzyPredictNN( model, testImage, K, proximityWeight)
% Tests an image, testImage, against a NN model and returns the closest
% prediction possible.
% If K is given, uses the nearest K neighbours instead of single nearest.
    minLabel = 0;

    if nargin == 2 || K == 1
        % Single NN
        minDistance = Inf;
        % Get the minimum euclidean distance & associated label from the test
        % image to the samples in the model.
        for i=1:size(model.samples, 1)
            distance = EuclidianDistance(testImage, model.samples(i, :));
            if distance < minDistance
                minDistance = distance;
                minLabel = model.labels(i);
            end
        end
        % Owing to the way in which single NN works, the sub-sample range
        % being only one entity large, it will always be 100% confident in
        % the result it returns
        confidence = 1;
    else
        % K Nearest Neighbours
        minDistances = [];
        for i=1:K
           minDistances(i, :) = [Inf, 0];
        end
        confidences = [];
        for i=1:size(model.samples, 1)
            distance = EuclidianDistance(testImage, model.samples(i, :));
            [maxVal maxIndex] = max(minDistances(:, 1));
            
            % If a given label from the sample has not been added for
            % confidence level consideration, add it to the Confidences
            % array
            if size(confidences,1) == 0 || ~any(confidences(:,1)==model.labels(i))
                confidences = [confidences;model.labels(i),0];
            end
            
            % If distance is less than the highest value in minDistances
            % then it deserves that spot.
            if distance < maxVal
                minDistances(maxIndex, :) = [distance, model.labels(i)];
            end
        end
        
        %Confidence calculation
        %This attempts to determine the probabilities that the given test 
        %image belongs to each one of the labels from the K-large subsample 
        
        %This calculation works by calculating the weighted effect of each image 
        %in the K-large subsample as it pertains to the test image based 
        %off of their proximity to the test image. Using this, the probability 
        %of each label being the one the test image belongs to can be
        %calculated
        %http://sci2s.ugr.es/keel/pdf/algorithm/articulo/1985-IEEE_TSMC-Keller.pdf
        
        %If no weight is supplied, or the supplied weight is invalid,
        %default to 2, the same default as used in the paper
        %A lower weight value means that closer neighbours are weighted
        %more strongly, while a higher weight value means that all
        %neighbours
        if nargin < 4 || proximityWeight <=1
            proximityWeight = 2;
        end
        
        %Pre-computation of the denominator of the equation
        %As the equation determines the ratio of each label's effect on the
        %test image, so this value will be used multiple times, once for
        %each label and denotes the total weighting of the sample.
        denominator = 0;
        for i=1:K
            denominator = denominator + 1 / ( (minDistances(i,1) ^ ( 2 / (proximityWeight - 1) ) ) );
        end
        
        %Each iteration of this outer loop calculates the weighting of the
        %effect of a given label as a ratio of the total subsample.
        for i=1:size(confidences,1)
            for j=1:K
                if (minDistances(j,2) == confidences(i,1))
                    confidences(i,2) = confidences(i,2) + 1 / ( (minDistances(j,1) ^ ( 2 / (proximityWeight - 1) ) ) );
                end
            end
            %This converts the derived ratio to a percentage
            confidences(i,2) = confidences(i,2) / denominator;
        end
        
        %By sorting the derived confidences in descending order, the label
        %the classifier is most confident in, along with the confidence
        %value of said label, are sorted to the bottom of the confidence
        %array
        confidences=sortrows(confidences,2); 
        minLabel = confidences(size(confidences,1),1);
        confidence = confidences(size(confidences,1),2);
    end
    
    prediction = minLabel;
end

