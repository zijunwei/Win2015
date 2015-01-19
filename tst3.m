% load positive data and negative data then see the results of the
% annotated
% clear;
Init;
 load('gt_positive.mat');
 load('hollywood2_thread');
% Answer Phone:
for i=1:1:12
trLb_i=trLb(i,:);

negs=find(trLb_i==-1);
neg_data=trD(negs,:);

fv_all=fv_pos{i};
Lbs=[ones(size(fv_all,2),1);-1*ones(size(neg_data,1),1)];
newtrD=[fv_all';neg_data];
newtrD=Zj_Normalization.l2(newtrD);
tstD=Zj_Normalization.l2(tstD);
Lambda=1e-6;
aps(i) = kerLSSVM_singleCate(Lambda, newtrD, Lbs, tstD, tstLb(i,:));
end
for i=1:length(classTxt)
    cls = classTxt{i};
    fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
end
fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));