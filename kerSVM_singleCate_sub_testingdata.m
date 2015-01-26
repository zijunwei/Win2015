% run basic kernel svm for single category
% difference between this function adn kerLSSSVM is that this only gives
% reustls for one category
% trD: n*d matrix for training data, each row is a FV, n is number of
% training instances. d is approximately 1000,000
% trLb: n*1 label vector for training data should be +1 and -1
% cau
function aps = kerSVM_singleCate_sub_testingdata( trD, trLb_i, fv_cell, tstLb)
addpath('/Users/zijunwei/Dev/MatlabLibs/libsvm/matlab');
C=100;
trK = trD'*trD;
trK = [(1:size(trK,1))', trK];


trLb_i(trLb_i == 0) = -1;
model = libsvmtrain(trLb_i, trK, sprintf('-t 4 -c %g -q', C));






tstLb(tstLb == 0) = -1;


prob=zeros(length(fv_cell),1);
for i=1:1:length(fv_cell)
    fv_v=fv_cell{i};
    fv_v=normalizations.power2(fv_v);
    fv_v=Zj_Normalization.l2_col(fv_v);
    tstK=fv_v'*trD;
    tstK = [(1:size(tstK,1))', tstK];
    tmpLb=zeros(size(tstK,1),1);
    [~, ~, prob_v] = libsvmpredict(tmpLb, tstK, model,'-q');
    prob_v = prob_v*model.Label(1);
    prob(i)=max(prob_v);
end


%prob=tstK*alphas+b;
aps= ml_ap(prob, tstLb, 0);

end