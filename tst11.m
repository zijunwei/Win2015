%tst11
% using pca to visualize the clusters
% positive threads *
% negative threads in positive video ^
% negative threads in negative video V
% Init;
% load('fv_neg_pos');
% load('gt_positive');
% load('H2_trD_sumThread_p2l2.mat');
% load('H2_rawtrLb');
% test on the first
i=2;

%positive thread
data_pos=fv_pos{i};

% negative thread in positive video
data_neg=fv_neg{i};

% negative all
trLb_i=raw_trLb(i,:);
negs=find(trLb_i==-1);
data_neg_neg=trD(:,negs);


num_pos=size(data_pos,2);
num_neg=size(data_neg,2);
%data_all=[data_pos,data_neg];

data_all=[data_pos,data_neg,data_neg_neg];
data_all=Zj_Normalization.l2_col(data_all);
[coeff,socre, latent]=princomp(data_all'*data_all);
%%
krD=data_all'*data_all;
prjD=krD*coeff(:,1:3);
%%
figure;
disp(classTxt{i})
scatter3(prjD(1:num_pos,1),prjD(1:num_pos,2),prjD(1:num_pos,3),50,'*');
hold on;
scatter3(prjD(num_pos+1:num_pos+num_neg,1),prjD(num_pos+1:num_pos+num_neg,2),prjD(num_pos+1:num_pos+num_neg,3),50,'v')
 
 scatter3(prjD(num_pos+num_neg+1:2:end,1),prjD(num_pos+num_neg+1:2:end,2),prjD(num_pos+num_neg+1:2:end,3),5,'^')
