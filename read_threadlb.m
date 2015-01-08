% training data iteratively

clear;
close all;
clc;

max_num=5;
% decide whehter load from test files or from training files

Lb_file_dir='/Users/zijunwei/Dev/Win2015/DataFromServer/ClipSets/';
Lb_file_pattern='*_test.txt';
Lb_file=dir(fullfile(Lb_file_dir,Lb_file_pattern));
Lb_all=[];

for f=1:1:length(Lb_file)
    Lb_info=read_clipsets(fullfile(Lb_file_dir,    Lb_file(f).name));
    Dta_dir='/Users/zijunwei/Dev/Win2015/DataFromServer/fv_thread';
    n_files=length(Lb_info.label);
  
    id=1;
    Lb_t=[];
    for i=1:1:n_files
        if f==1
            if mod(i,5)==0
                fprintf('processing %d/%d \n',i,n_files);
            end
            Lb=Lb_info.label(i);
            file_name=[Lb_info.fname{i},'_*.mat'];
            files=dir(fullfile(Dta_dir,file_name));
            num(i)=length(files);
            
            
            if num(i)>max_num
                
                num(i)=max_num;
            end
            
        end
        for j=1:1:num(i)
            file_id=combnk(1:num(i),j);
            for k=1:1:size(file_id,1)
                Lb_t=[Lb_t,Lb];
            end
        end
    end
    
    Lb_all=[Lb_all;Lb_t];
    
end

