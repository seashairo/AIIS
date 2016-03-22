function [ ] = displayResults( testImages, testLabels, results, imX, imY )
    comparison = (testLabels == results);

    ii = 1;
    jj = 1;
    figure('Name','Correct', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
    while ii <= size(testImages, 1)
        if comparison(ii)
            subplot_tight(5, 10, jj);
            im = reshape(testImages(ii,:), [imY, imX]);
            imshow(im);
            imTitle = sprintf('L=%d, P=%d', testLabels(ii), results(ii));
            title(imTitle);
            jj = jj + 1;
            if jj == 51
                jj = 1;
                figure('Name','Correct', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
            end
        end
        ii = ii + 1;
    end

    ii = 1;
    jj = 1;
    figure('Name','Incorrect', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
    while ii <= size(testImages, 1)
        if ~comparison(ii)
            subplot_tight(5, 10, jj);
            im = reshape(testImages(ii,:), [imY, imX]);
            imshow(im);
            imTitle = sprintf('L=%d, P=%d', testLabels(ii), results(ii));
            title(imTitle);
            jj = jj + 1;
            if jj == 51
                jj = 1;
                figure('Name','Incorrect', 'NumberTitle', 'Off', 'Position', [100, 100, 960, 900]);
            end
        end
        ii = ii + 1;
    end
end

