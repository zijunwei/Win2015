function [predLabel, prob, TPR, FPR] = ml_LR_predict(TestData, w0, w, desLabel)
% function predLabel = ml_LR_predict(TestData, w0, w)
% Perform Logistic Regression prediction
% Inputs:
%   TestData: data in column format
%   w0, w: model parameters of Logistic Regression
%   desLabel: desire label, this could be empty.
% Outputs:
%   predLabel: predicted labels of TestData.
%   prob: a column vector telling the probability of data points belonging to class 1.
%   TPR: true positive rate
%   FPR: false positive rate
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 6 Aug 2007

w = [w0; w];
[d,n] = size(TestData);

X = ones(d+1,n);
X(2:end,:) = TestData;

predLabel = double(X'*w > 0);
if nargout >= 2
    prob = 1./(exp(-X'*w) + 1);
    prob(isnan(prob)) = 1;
end;
if nargout == 4
    if exist('desLabel', 'var') && length(desLabel) == size(TestData,2)
        nP = sum(desLabel == 1);
        nN = length(desLabel) - nP;
        nTP = sum(predLabel(desLabel == 1));
        nFP = sum(predLabel) - nTP; 
        TPR = nTP/nP;
        FPR = nFP/nN;
    else
        error('ml_LR_predict.m: desLabel required');
    end;
end;
    