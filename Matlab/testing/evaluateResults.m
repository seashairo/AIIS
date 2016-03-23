function [ output ] = evaluateResults( labels, results )
% Takes a set of labels and a set of results and calculates a set of
% correctness values.
% Values are accuracy, TP, FP, TN, TN, recall, precision, specificity, F1, False
% Alarm Rate

    output = struct();
    comp = (labels == results);
    output.accuracy = sum(comp) / length(comp);
    
    output.tp = sum((labels == 1) & (labels == results));
    output.tn = sum((labels == 0) & (labels == results));
    output.fp = sum((labels == 0) & (labels ~= results));
    output.fn = sum((labels == 1) & (labels ~= results));
    
    output.recall = output.tp/(output.tp+output.fn);
    output.precision = output.tp/(output.tp+output.fp);
    output.specificity = output.tn/(output.tn+output.fp);
    output.f1 = (2 * output.tp) / ((2*output.tp) + output.fn + output.fp);
    output.far = output.fp/(output.fp+output.tn);

end

