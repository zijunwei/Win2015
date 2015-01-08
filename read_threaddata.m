% training data iteratively

clear;
close all;
clc;

max_num=5;
% decide whehter load from test files or from training files
Lb_file='/Users/zijunwei/Dev/Win2015/DataFromServer/ClipSets/AnswerPhone_train.txt';
Lb_info=read_clipsets(Lb_file);

Dta_dir='/Users/zijunwei/Dev/Win2015/DataFromServer/fv_thread';

n_files=length(Lb_info.label);
%idx=1;
fv_t=[];
Lb_t=[];
for i=1:1:n_files
    if mod(i,5)==0
        fprintf('processing %d/%d \n',i,n_files);
    end
    Lb=Lb_info.label(i);
    file_name=[Lb_info.fname{i},'_*.mat'];
    files=dir(fullfile(Dta_dir,file_name));
    num=length(files);
    s=[];
    fv_file=[];
    for idx=1:1:length(files)
        [ fv_file{idx},s(idx)]=form_fv(fullfile(Dta_dir,files(idx).name));
    end
    if num>max_num
        [~,idxx]=sort(s,'descend');
        fv_file=fv_file(idxx(1:max_num));
        num=max_num;
    end
    
    for j=1:1:num
        file_id=combnk(1:num,j);
        for k=1:1:size(file_id,1)
            fv=[];
            for m=1:1:size(file_id,2)
                if isempty(fv)
                    fv=fv_file{file_id(k,m)};
                else
                    tmp=fv_file{file_id(k,m)};
                    fv=fv+tmp;
                end
                
            end
            fv=fv/size(file_id,2);
            fv_t=[fv_t ;fv];
            Lb_t=[Lb_t,Lb];
        end
    end
end


