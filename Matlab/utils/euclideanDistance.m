function [ distance ] = euclideanDistance( a, b )
% Returns the euclidean distance of two matrices.
    c = a - b;
    distance = sqrt(sum(c .* c));
end