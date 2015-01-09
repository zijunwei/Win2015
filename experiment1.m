% experiment 1
% using thread video
% positive data: sum up of all positive threads in a video. i.e the first
%                item in fv_arg
% negative data: the combinations of negative threads in videos


clear;
run('../ZFunc/Zj_Setup.m');
load('argumented_fv_train.mat');
load('clipset_macmini.mat');

classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};


%training stage
% extracting positive data
for idx=1:1:length(training_clipset)
fprintf('processing %d \n',idx);
pos_fv=[];
refinfo=read_clipsets(training_clipset{idx});
pos_lb=find(refinfo.label==1);

for i=1:1:length(pos_lb)
    pos_fv=[pos_fv;arg_fv(i).fv{1}];
end

%extracting negative data
neg_fv=[];
neg_lb=find(refinfo.label==-1);
for i=1:1:length(neg_lb)
    for j=1:1:length(arg_fv(i).fv)
        neg_fv=[neg_fv;arg_fv(i).fv{j}];
    end
    
end
trD=[pos_fv;neg_fv];
trD=Zj_Normalization.l2(trD);
trLb=[ones(1,length(pos_lb)),-1*ones(1,size(neg_fv,1))];


% extacting testing data
tst_refinfo=read_clipsets(testing_clipset{idx});
tstLb=tst_refinfo.label;


save(sprintf('%s_arg_neg.mat',classTxt{idx}),'trD','trLb','tstLb','-v7.3');
end
