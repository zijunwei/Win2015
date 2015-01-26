% sum of  sum of negative threads in positive data  + sum of all FV in negative videos
% clear;
Init;
 load('fv_neg_pos.mat');
 load('H2_trD_sumThread_p2l2.mat');
 load('H2_tstD_sumThread_p2l2.mat');
load('H2_tstLb');
load('H2_rawtrLb');
 
% Answer Phone:
for i=1:1:12
    fprintf('processing %s \n',classTxt{i});
trLb_i=raw_trLb(i,:);

negs=find(trLb_i==-1);
neg_data=trD(:,negs);
% poss=find(trLb_i==1);
% fv_all1=trD(:,poss);
fv_all=fv_neg{i};

fv_all=normalizations.power2(fv_all);
Lbs=[ones(size(fv_all,2),1);-1*ones(size(neg_data,2),1)];
newtrD=[fv_all,neg_data];

newtrD=Zj_Normalization.l2_col(newtrD);
%tstD=normalizations.power2(tstD);
tstD=Zj_Normalization.l2_col(tstD);
trK=newtrD'*newtrD;
tstK=tstD'*newtrD;
Lambda=1e-6;
aps(i) = svms.kerLSSVM_s( trK, Lbs, tstK, tstLb(i,:),Lambda);
end
for i=1:length(classTxt)
    cls = classTxt{i};
    fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
end
fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));