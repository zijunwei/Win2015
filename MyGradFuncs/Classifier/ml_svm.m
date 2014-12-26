function [predicted, model, decisionValues, tr_tpr, tr_tnr, tst_tpr, tst_tnr, tr_acc, tst_acc] =  ...
    ml_svm(trainData, testData, trainLabel, testLabel, opts, shldCmpTrainRate)
% predicted = ml_svm(trainData, testData, trainLabel, testLabel, opts)
% train SVM classifier and test on test data.
% Inputs:
%   trainData, testData: train and test data, given in column format.
%   trainLabel: labels of train data points. This is a column vector,
%       trainLabel(i) is the label of column i_th of trainData.
%   testLabel: ground truth labels of the test data. This is just to help
%       the LibSVM to compute the error of the classification. If testLabel
%       is unkown, it can be set to [].
%   opts: the options of svmtrain.
% Outputs:
%   predicted: predicted labels of test data, this is a column vector.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 26 June 07.


posTrIdxs = find(trainLabel == 1);
negTrIdxs = find(trainLabel == -1);
nPos = length(posTrIdxs);
nNeg = length(negTrIdxs);

% Include option for reweighting two classes
opts = sprintf('%s -w1 %g -w-1 %g', opts, 1/nPos, 1/nNeg);
model = svmtrain(trainLabel, trainData', opts);  

if exist('shldCmpTrainRate', 'var') && shldCmpTrainRate
    [predicted, dc, decisionValues] = svmpredict(trainLabel, trainData', model);

    tr_tpr = sum(predicted(posTrIdxs) == 1)/length(posTrIdxs);
    tr_tnr = sum(predicted(negTrIdxs) == -1)/length(negTrIdxs);
    tr_acc = sum(predicted == trainLabel)/length(trainLabel);
    fprintf('ml_svm training: TPR: %g, TNR: %g, ACC: %g\n', ...
        tr_tpr, tr_tnr, tr_acc);
    
else
    predicted = [];
    tr_tpr    = [];
    tr_tnr    = [];
    tr_acc = [];
end;

if ~isempty(testData)
    if isempty(testLabel)
        testLabel = zeros(size(testData,2),1);
    end;
    [predicted, dc, decisionValues] = svmpredict(testLabel, testData', model);

    posTstIdxs = find(testLabel == 1);
    negTstIdxs = find(testLabel == -1);

    tst_tpr = sum(predicted(posTstIdxs) == 1)/length(posTstIdxs);
    tst_tnr = sum(predicted(negTstIdxs) == -1)/length(negTstIdxs);
    tst_acc = sum(predicted == testLabel)/length(testLabel);
    fprintf('ml_svm.m, testing: TPR: %g, TNR: %g, ACC: %g\n', ...
        tst_tpr, tst_tnr, tst_acc);
end;