% experiment 3 and 4

% experiment thread + linear svm used
% all the data are sum of fisher vectors from all videos

Init;
load('H2_trD_sumThread_p2l2.mat');
load('H2_tstD_sumThread_p2l2.mat');
load('H2_tstLb');
load('H2_rawtrLb');

% exp1
%aps=svms.kerSVM(100,trD',trLb,tstD',tstLb,classTxt);


% exp2
%aps=svms.kerLSSVM(1e-6,trD,raw_trLb  ,tstD,tstLb,classTxt);