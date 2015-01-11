%experiment 2 using simple data
% iterative svm:
%  Since we have a problem in removing the degeneration of data, we start
%  with the simple data


clear;
Init;
% add dependences:
load('hollywood2_thread.mat');
% % load thread test data and test label
% load('H2_tstD_l2.mat');
% load('H2_rawtrLb.mat');% 823 training data labels

load('argumented_fv_train.mat'); % load all the training threads 

%set up parameters
lamda=1e-6;


i=1;
load(sprintf('%s_arg_neg.mat',classTxt{i}));
trLb_i=trLb(i,:);
pos_ind=find(trLb_i==1);
[alpha,b,trD]=lssvm_iterative(lamda,trD,trLb,arg_fv,pos_ind);
% test
confid=alpha*(trD*tstD')+b;
aps(i)=ml_ap(confid,tstLb,0);
