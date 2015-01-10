% trD: d*n matrix for training data, each column is a FV, n is number of training instances
% trLb: 12*n label matrix for training data should be +1 and -1
% trLb(i,:) is binary lable vector for class i. trLb(i,j) is the label of video j for class i.
% it: set number of iterations to stop the lssvm classifer
function aps = kerLSSVM_iterative(Lambda, trK, trLb, tstK, tstLb,it)
addpath('/Users/zijunwei/Dev/MatlabLibs/libsvm/matlab');
% trK = trD*trD';
% tstK = tstD*trD';


trLb(trLb == 0) = -1;
tstLb(tstLb==0)=-1;
fprintf('Train LSSVMs\n');
trLb(trLb == 0) = -1;
for i=1:it
    fprintf('training LSSVM model  iteration %d\n', i);
    n=length(trLb);
    s=ones(n,1)/(n);
    Lambda0=Lambda*n;
    [alphas,b]=ML_Ridge.kerRidgeReg(trK,double(trLb)',Lambda0,s);
    
    prob=trK*alphas+b;
    trLb(prob<0.2)=-1;
end;

fprintf('Test iterated LSSVM');

prob=tstK*alphas+b;
aps = ml_ap(prob, tstLb, 0);
end
