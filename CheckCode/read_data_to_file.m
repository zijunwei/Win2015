clear;
clc;
close all;

txt_data_dir='/nfs/bigeye/zijun/Ixmas_dt';
save_mat_dir='/nfs/bigeye/zijun/Ixmas_dt_mat';

if ~exist(save_mat_dir,'dir')
   mkdir(save_mat_dir);
end
trj_len=466;
txt_files=dir(fullfile(txt_data_dir,'*.txt'));
for i=randperm( length(txt_files))
    output_file=fullfile(save_mat_dir, [txt_files(i).name,'.mat']);
if ~exist(output_file,'file')
   unix(['touch ',output_file]);
   trj_mat=check_read_data(output_file,trj_len);
   save(output_file,'trj_mat');
else
    continue;
end
    
end
