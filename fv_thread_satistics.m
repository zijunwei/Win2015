% get how many thread each video contains in training data.
Init;
 file_dir_string='/Users/zijunwei/Dev/Win2015/DataFromServer/fv_thread';
 
 %ref_file='/Users/zijunwei/Dev/Win2015/DataFromServer/ClipSets/AnswerPhone_train.txt';
 ref_file='/Users/zijunwei/Dev/Win2015/DataFromServer/ClipSets/AnswerPhone_test.txt';
 
 
 ref_info=read_clipsets(ref_file);
 
 
 num_threads=zeros(length(ref_info.fname),1);
 
 % method 1 is time consuming
%  for i=1:1:length(ref_info.fname)
%      file_pattern=ref_info.fname{i};
%      thread_files=dir(fullfile(file_dir_string,[file_pattern,'_*.mat']));
%      num_threads(i)=length(thread_files);
%      
%      
%  end

%method 2  this is much much faster!!!
% because it doesn't access file reading all the time.
thread_files=dir(fullfile(file_dir_string,'*.mat'));
thread_file_names={thread_files.name};
 for i=1:1:length(ref_info.fname)
     file_pattern=ref_info.fname{i};
      ind=strfind(thread_file_names,file_pattern);
       index  = find(~cellfun(@isempty,ind));
       num_threads(i)=length(index);     
     
 end