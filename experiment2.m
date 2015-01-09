%experiment 2
% iterative svm

addpath_recurse('./MyGradFuncs');
% load thread test data and test label
load('H2_tstD_l2.mat');
load('H2_tstLb.mat');
load('H2_rawtrLb.mat');
classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};
load('argumented_fv_train.mat'); % load all the training threads 

%set up parameters
lamda=1e-6;



i=1;
load(sprintf('%s_arg_neg.mat',classTxt{i}));
trLb_i=raw_trLb(i,:);
pos_ind=find(trLb_i==1);
[alpha,b,trD]=iterative_lssvm(lamda,trD,trLb,arg_fv,pos_ind);
% test
confid=alpha*(trD*tstD')+b;
aps(i)=ml_ap(confid,tstLb,0);
