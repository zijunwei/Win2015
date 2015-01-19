%test kerLSSVM_singleCate_iterative1 in svms


Init;
disp('loading files ... \n')
%file_pattern='%s_psni_l2.mat';
load('uid_tr_struct_nl2.mat');
load('H2_tstLb');
load('H2_tstD_l2');
load('H2_rawtrLb');
load('H2_rawtrD');
load('num_thread_per_training_video');
lambda=1e-6;

aps=zeros(length(classTxt),1);

for i=1:1:length(classTxt)
    fprintf('processing %s \n',classTxt{i});
    % if starting from raw data no need to do this
    % load(sprintf(file_pattern,classTxt{i}));
    tstLb_i=tstLb(i,:);
    % normal iterative
    
    aps(i)=svms_v2.kerLSSVM_singleCate_iterative1(lambda,trD_raw,raw_trLb(i,:),tstD,tstLb_i,fv_info,num_threads);
    
    %    % cross validataion loocv
    %    %     aps(i)=svms.kerLSSVM_singleCate_cv(lambda,trD,trLb',tstD,tstLb_i,fv_info,,num_threads,trD_raw);
    %
    %    % start from the baseline, fix the positive data
    %  apsfp(i) = svms_v2.kerLSSVM_singleCateFP(lambda,trD_raw, raw_trLb(i,:),tstD, tstLb_i,fv_info,num_threads);
    %      % start from the baseline fix the negative data
    % apsfn(i) = svms_v2.kerLSSVM_singleCateFN(lambda,trD_raw, raw_trLb(i,:),tstD, tstLb_i,fv_info,num_threads);
    
end

for i=1:length(classTxt)
    cls = classTxt{i};
    fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
end
fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));