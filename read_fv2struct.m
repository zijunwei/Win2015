% extract argumented fisher vectors from fv_thread
% the structure of each element:
% arg_fv.tags  --   file name pattern E.g: autotrainclip00001
% arg_fv.file_names --   sub-file names:  E.g autotrainclip00001_001
% arg_fv.fv    --   sub-file fisher vectors for each sub-file
% NOT Normalized 

function arg_fv=read_fv2struct()
% setup my own function
run('../ZFunc/Zj_Setup.m');
max_file=3;
ref_info=read_clipsets('/Users/zijunwei/Dev/Win2015/DataFromServer/ClipSets/AnswerPhone_train.txt');
% file_dir_string='/Users/zijunwei/Dev/Win2015/DataFromServer/fv_thread';

 load('fv_thread_struct.mat')

 arg_fv = struct('tag',{},'file_names',{},'fv',{});
 allnames={fv_struct.name};
for i=1:1:length(ref_info.label)
    arg_fv(i).tag=ref_info.fname{i};
    idx=1;
    sub_files=dir(fullfile(file_dir_string,[arg_fv(i).tag,'_*.mat']));
    num_files=length(sub_files);
      % if the number of files is larger than max_file, we only use C(n,n)+C(n,n-1)+...+C(n,n-max_file+1)
    tmp=max_file;
    if num_files<max_file
        
        tmp=num_files;
    end
        for j=num_files:-1:num_files-tmp+1
            
            combid=combnk(1:num_files,j);
            for k=1:1:size(combid,1)
                fv=[];
                for m=1:1:size(combid,2)
                    
                    ind=find(ismember(allnames, sub_files(combid(k,m)).name));
                    temp_struct=fv_struct(ind);
                    if isempty(fv)
                        fv= temp_struct.fv;
                    else
                        fv=fv+temp_struct.fv;
                    end
                    arg_fv(i).file_names(idx).names{m}=sub_files(combid(k,m)).name;
                end
                arg_fv(i).fv{idx}=fv;
                idx=idx+1;
                
            end
        end
        
   
        
        
    
    
    
end
end