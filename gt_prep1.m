% get all positive data from threads

load('annotation_info.mat');

load('trVideoNames.mat');
load('H2_rawtrLb');
fv_dir='./DataFromServer/fv_thread';
for i=1:1:12
idx=find(Anno(:,i)==1);
fv_pos{i}=[];


for j=1:1:length(idx)
    file_name=fullfile(fv_dir,file_stems{idx(j),1});
    file_name=[file_name,'.mat'];
    if exist(file_name,'file')
    fv=read_fv_from_file(file_name);
    fv_pos{i}=[fv_pos{i},fv];
    end
end
end