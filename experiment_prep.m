% experiment prep
% extract thread video
% positive data: sum up of all positive threads in a video. i.e the first
%                item in fv_arg
% negative data: the combinations of negative threads in videos


clear;
load('argumented_fv_train.mat');
load('clipset_macmini.mat');

classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};

fv_dim=109056;
%training stage
% extracting positive data
for idx=1:1:length(classTxt)
fprintf('processing %d \n',idx);
refinfo=read_clipsets(training_clipset{idx});
pos_lb=find(refinfo.label==1);

pos_fv=zeros(length(pos_lb),fv_dim);
for i=1:1:length(pos_lb)
    pos_fv(i,:)=arg_fv(pos_lb(i)).fv{1};
end

%extracting negative data speeding up, prealocate storage
neg_lb=find(refinfo.label==-1);
dm_counter=0;
for i=1:1:length(neg_lb)
        dm_counter=dm_counter+length(arg_fv(neg_lb(i)).fv);
end
neg_fv=zeros(dm_counter,fv_dim);
counter=1;
for i=1:1:length(neg_lb)
    for j=1:1:length(arg_fv(neg_lb(i)).fv)
        neg_fv(counter,:)=[arg_fv(neg_lb(i)).fv{j}];
        counter=counter+1;
    end
    
end
trD=[pos_fv;neg_fv];
trD=Zj_Normalization.l2(trD);
trLb=[ones(1,length(pos_lb)),-1*ones(1,size(neg_fv,1))];


save(sprintf('%s_arg_neg_l2.mat',classTxt{idx}),'trD','trLb','-v7.3');
end
