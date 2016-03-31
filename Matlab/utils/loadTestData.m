function [ Coordinates ] = loadTestData(filename)

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

line1=fgetl(fp);

numberOfItems = fscanf(fp,'%d',1);

Coordinates = [];
for ii=1:numberOfItems
    
    fscanf(fp,'%s',1);
    NumBox = fscanf(fp,'%d',1);
    Coordinates(ii, 1) = NumBox;
    for jj = 2 : NumBox*5+1;
       
        Coordinate = fscanf(fp,'%f',1);
        if mod(jj,5) == 4 || mod(jj,5) == 0
            Coordinates(ii, jj-2) = Coordinates(ii, jj-2) - Coordinate/2;
        end
        Coordinates(ii, jj) = Coordinate;
    end
end

fclose(fp);

end