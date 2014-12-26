function [w, b] = ml_L1SVM(Data, label, C, shldDisp)
% function [w, b] =  ml_L1SVM(Data, label, C)
% L1-SVM
% This function tries to balance the size of two classes. 
% This function also balances between C and # of constraints; thus
% even the number of samples increase, the C can be kept constant. 
% Inputs:
%   Data: Data matrix of size d*n, d: # features, n: # training data.
%   label: corresponding labels of training data, this is column vector.
%       the entries must be either 1 or -1.
%   C: the parameter C of linear SVM.
%   shldDisp: should display the training error?
% Outputs:
%   w: weights for each features.
%   b: the b of the SVM.
% See also: ml_minhSVM
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 29 Nov 2008

[d, n] = size(Data);
nPos = sum(label == 1);
nNeg = sum(label == -1);


% weights for constraints
constrW = zeros(n, 1);
constrW(label == 1)  = 1/nPos;
constrW(label == -1) = 1/nNeg;

LabelData = repmat(label', d, 1).*Data;

cvx_clear;
cvx_precision high;
cvx_quiet(true);
cvx_begin
    variable w(d);
    variable xi(n);
    variable b;
    minimize( norm(w,1) + C*(constrW'*xi));
    subject to
        LabelData'*w + b*label + xi >= 1;
        xi >= 0;
cvx_end

if strcmp(cvx_status, 'Failed')
    error('ml_minhSVM: CVX failed to optimize. I dont know what to do.');
end;
            
if exist('shldDisp', 'var') && shldDisp
    svmScore = w'*Data + b;
    fprintf('ml_L1SVM: true positive rate: %.2f\n', sum(svmScore(label == 1) > 0)/nPos);
    fprintf('ml_L1SVM: true negative rate: %.2f\n', sum(svmScore(label ==-1) < 0)/nNeg);   
    fprintf('ml_L1SVM: # of non-zero weights: %d\n', sum(abs(w) > 1e-5/n));
end;

