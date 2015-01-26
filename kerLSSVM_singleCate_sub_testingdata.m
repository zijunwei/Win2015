% run basic kernel svm for single category
% difference between this function adn kerLSSSVM is that this only gives
% reustls for one category
% trD: n*d matrix for training data, each row is a FV, n is number of
% training instances. d is approximately 1000,000
% trLb: n*1 label vector for training data should be +1 and -1
% cau
function aps = kerLSSVM_singleCate_sub_testingdata(Lambda, trD, trLb_i, fv_cell, tstLb)
trK = trD'*trD;
%tstK = fv_cell*trD';



trLb_i(trLb_i == 0) = -1;

tstLb(tstLb == 0) = -1;
n=length(trLb_i);
s=ones(n,1)/(n);
Lambda0=Lambda*n;
[alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_i,Lambda0,s);

prob=zeros(length(fv_cell),1);
for i=1:1:length(fv_cell)
   fv_v=fv_cell{i};
   fv_v=normalizations.power2(fv_v);
   fv_v=Zj_Normalization.l2_col(fv_v);
   pro_v=fv_v'* trD*alphas+b;
   prob(i)=max(pro_v);
end


%prob=tstK*alphas+b;
aps= ml_ap(prob, tstLb, 0);

end