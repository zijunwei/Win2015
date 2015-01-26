%same as tst6 but useing Linear SVM
% load positive data -- annotated and negative data : single threads then see the results of the
% annotated
% clear;
Init;
 load('gt_positive.mat');
 load('H2_tstLb');
 load('H2_rawtrLb')
 load('uid_tr_struct_NONl2.mat');
 %load all negative threads
 fv_cell=preprocessing_uid_struct2(fv_info);
 load('uid_tst_struct_NONl2.mat');
%  % preprocessing test dat:
 fv_cell_tst=preprocessing_uid_struct2(fv_info);

for i=1:1:12
    fprintf('processing %s \n',classTxt{i});
trLb_i=raw_trLb(i,:);

negs=find(trLb_i==-1);
neg_data=[fv_cell{negs}];

fv_all=fv_pos{i};
Lbs=[ones(size(fv_all,2),1);-1*ones(size(neg_data,2),1)];
newtrD=[fv_all,neg_data];
newtrD=normalizations.power2(newtrD);
newtrD=Zj_Normalization.l2_col(newtrD);

aps(i) = kerSVM_singleCate_sub_testingdata(newtrD, Lbs, fv_cell_tst, tstLb(i,:));
end
for i=1:length(classTxt)
    cls = classTxt{i};
    fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
end
fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));