function [lambdas, b, predicted, tst_tpr, tst_tnr, tst_acc, tr_tpr, tr_tnr, tr_acc] ...
    = ml_svm_fixedSVs(TrD, trL, SVs, TstD, tstL, opts, shldCmpTrainRate)
% [lambdas, b, predicted, tst_tpr, tst_tnr, tst_acc, tr_tpr, tr_tnr, tr_acc] ...
%    = ml_svm_fixedSVs(TrD, trL, SVs, TstD, tstL, opts, shldCmpTrainRate)
% Perform Gaussian SVM, the set of SVs are predefined.
% Inputs:
%   TrD: d*n matrix for train data
%   TrL: n*1 vector for label (-1, +1)
%   SVs: d*k matrix for support vectors
%   TstD: [] or d*m matrix for test data
%   tstL: [] or m*1 vector for test label
%   opts.C, opts.gamma: C and gamma of Gaussian kernel
%   sldCmpTrainRate: should compute stats for train data
% Outputs:
%   lambdas, b: the decision value for x: sum_i lambdas(i)*k(SVs(:,i), x) + b.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 8 Aug 09


posTrIdxs = find(trL == 1);
negTrIdxs = find(trL == -1);
nPos = length(posTrIdxs);
nNeg = length(negTrIdxs);
nSV = size(SVs,2);

PosTrD = TrD(:, posTrIdxs);
NegTrD = TrD(:, negTrIdxs);
gamma = opts.gamma;
C = opts.C;

KSVSV = exp(-gamma*ml_sqrDist(SVs, SVs));
KPosTrDSVs = exp(-gamma*ml_sqrDist(PosTrD, SVs));
KNegTrDSVs = exp(-gamma*ml_sqrDist(NegTrD, SVs));

cvx_begin
    variable lambdas(nSV);
    variable alphas(nPos);
    variable betas(nNeg);
    variable b;
    minimize(0.5*quad_form(lambdas, KSVSV) + C/nPos*sum(alphas) + C/nNeg*sum(betas)); 
    subject to
        KPosTrDSVs*lambdas + b >= 1 - alphas; 
        KNegTrDSVs*lambdas + b <= -1 + betas;
        alphas >= 0;
        betas >= 0;
cvx_end


if exist('shldCmpTrainRate', 'var') && shldCmpTrainRate
    tp = sum(KPosTrDSVs*lambdas + b >= 0);
    tn = sum(KNegTrDSVs*lambdas + b < 0);
    tr_tpr = tp/nPos;
    tr_tnr = tn/nNeg;
    tr_acc = (tp + tn)/(nPos + nNeg);

    fprintf('ml_svm training: TPR: %g, TNR: %g, ACC: %g\n', ...
        tr_tpr, tr_tnr, tr_acc);
else
    predicted = [];
    tr_tpr    = [];
    tr_tnr    = [];
    tr_acc = [];
end;

if ~isempty(TstD)
    KTstDSVs = exp(-gamma*ml_sqrDist(TstD, SVs));
    tstDecVals = KTstDSVs*lambdas + b;
    predicted = ones(size(tstDecVals));
    predicted(tstDecVals < 0) = -1;
    if isempty(tstL)
        tst_tpr = [];
        tst_tnr = [];
        tst_acc = [];
    else
        posTstIdxs = find(tstL ==  1);
        negTstIdxs = find(tstL == -1);

        tst_tpr = sum(predicted(posTstIdxs) == 1)/length(posTstIdxs);
        tst_tnr = sum(predicted(negTstIdxs) == -1)/length(negTstIdxs);
        tst_acc = sum(predicted == tstL)/length(tstL);
        fprintf('ml_svm.m, testing: TPR: %g, TNR: %g, ACC: %g\n', ...
            tst_tpr, tst_tnr, tst_acc);
    end
end;
