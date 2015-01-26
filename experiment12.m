% experiment 1 & 2
%1. Re-implement Heng Wang's Paper non-thread fv + linear svm 
%c=100 as indicated from paper


% 2. using the same thing, but using lssvm instead
Init;
load('/Users/zijunwei/Dev/Win2015/DataUseful/hollywood2.mat');

% exp1
%aps=svms.kerSVM(100,trD',trLb,tstD',tstLb,Lb_sets);


% exp2
aps=svms.kerLSSVM(1e-6,trD',trLb,tstD',tstLb,Lb_sets);