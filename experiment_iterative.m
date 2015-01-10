%experiment 2
% iterative svm:
%  use all the sum of threads in positive videos as positive example. Use 
% all the combinations of threads in negative videos as negative examples
% (C(n,1),C(n,2)...C(n,n)) if there are too many threads, preserve
% C(n,n),C(n,n-1)...C(n,x);
% for each training loop, use the computed svm model to test on every
% possible combinations of threads in positive data, for each iteration,
% add the maximum score into the training data.
% iterate until nothing to add.
% test on the testing data.


clear;

% add dependences:
addpath_recurse('./MyGradFuncs');
run('../ZFunc/Zj_Setup.m');
addpath('./ActionMat/')
% load thread test data and test label
load('H2_tstD_l2.mat');
load('H2_rawtrLb.mat');% 823 training data labels
classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};
load('argumented_fv_train.mat'); % load all the training threads 

%set up parameters
lamda=1e-6;


i=1;
load(sprintf('%s_arg_neg.mat',classTxt{i}));
trLb_i=raw_trLb(i,:);
pos_ind=find(trLb_i==1);
[alpha,b,trD]=lssvm_iterative(lamda,trD,trLb,arg_fv,pos_ind);
% test
confid=alpha*(trD*tstD')+b;
aps(i)=ml_ap(confid,tstLb,0);
