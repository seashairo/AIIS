function [objects] = simpleNMS(objects, imY, imX, threshold)
% Reduces overlap of bounding boxes.
removeMe = [];
fcount = 1;
for ii = 1 : size(objects,1)
    A = [objects(ii,1),objects(ii,2),imY,imX];
    for jj = 1 : size(objects,1)
        if ii == jj
            continue
        end
          B = [objects(jj,1),objects(jj,2),imY,imX];
          area = rectint(A,B);
          boundingArea = imY * imX;
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
removeMe = unique(removeMe);
objects(removeMe,:) = [];
end

