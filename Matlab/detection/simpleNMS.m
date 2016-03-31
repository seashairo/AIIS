function [objects] = simpleNMS(objects, threshold)
% Reduces overlap of bounding boxes.
removeMe = [];
fcount = 1;
for ii = 1 : size(objects,1)
    A = [objects(ii,1),objects(ii,2),objects(ii,4),objects(ii,5)];
    for jj = ii + 1 : size(objects,1)
          B = [objects(jj,1),objects(jj,2),objects(jj,4),objects(jj,5)];
          area = rectint(A,B);
          boundingArea = objects(ii,5) * objects(ii,4);
        if area/boundingArea > threshold
            %Remove the Object with the lower confidence.
            if objects(ii,3) > objects(jj,3)
                removeMe(1,fcount) = jj;
            else
                removeMe(1,fcount) = ii;
            end
            fcount = fcount + 1;
        end
    end
end
%remove duplicates.
objects(removeMe,:) = [];
end

