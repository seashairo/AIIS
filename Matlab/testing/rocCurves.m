function rocCurves(labels, classification, name)
% ROCCURVES Plots a roc curve for the given inputs.

[X,Y] = perfcurve(labels, classification,1);

figure()
plot(X,Y)
xlabel('False positive rate');
ylabel('True positive rate');
name = strcat('ROC Curve for', name); 
title(name);
end