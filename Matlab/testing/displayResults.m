function [ ] = displayResults( testImages, testLabels, results, imX, imY )
    comparison = (testLabels == results);
    correctFig = figure('Name','Correct', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
    incorrectFig = figure('Name','Incorrect', 'NumberTitle', 'Off', 'Position', [600, 100, 960, 900]);
    
    correctCount = 1;
    incorrectCount = 1;
    ii = 1;
    while ii <= size(testImages, 1)
        if comparison(ii)
            figure(correctFig);
            subplot_tight(5, 10, correctCount);
            im = reshape(testImages(ii,:), [imY, imX]);
            imshow(im);
            imTitle = sprintf('L=%d, P=%d', testLabels(ii), results(ii));
            title(imTitle);
            correctCount = correctCount + 1;
            if correctCount == 51
                correctCount = 1;
                correctFig = figure('Name','Correct', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
            end
        else
            figure(incorrectFig);
            subplot_tight(5, 10, incorrectCount);
            im = reshape(testImages(ii,:), [imY, imX]);
            imshow(im);
            imTitle = sprintf('L=%d, P=%d', testLabels(ii), results(ii));
            title(imTitle);
            incorrectCount = incorrectCount + 1;
            if incorrectCount == 51
                incorrectCount = 1;
                incorrectFig = figure('Name','Incorrect', 'NumberTitle', 'Off', 'Position', [600, 100, 960, 900]);
            end
        end
        ii = ii + 1;
    end
end

