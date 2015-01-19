% run basic kernel svm for single category
% difference between this function adn kerLSSSVM is that this only gives
% reustls for one category
% trD: n*d matrix for training data, each row is a FV, n is number of
% training instances. d is approximately 1000,000
% trLb: n*1 label vector for training data should be +1 and -1
% cau
function aps = kerLSSVM_singleCate(Lambda, trD, trLb_i, tstD, tstLb)
trK = trD*trD';
tstK = tstD*trD';



trLb_i(trLb_i == 0) = -1;

tstLb(tstLb == 0) = -1;
n=length(trLb_i);
s=ones(n,1)/(n);
Lambda0=Lambda*n;
[alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_i,Lambda0,s);


prob=tstK*alphas+b;
aps= ml_ap(prob, tstLb, 0);

end
