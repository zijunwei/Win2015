%    only get the positive threads that are not the whole of all the
%    threads. for example if there are 3 threads and 2 of them are
%    annotated as positive, then we get the 2 out.

clear;
load('annotation_info.mat');

load('trVideoNames.mat');
load('H2_rawtrLb');
fv_dir='./DataFromServer/fv_thread';
for i=1:1:12
idx=find(Anno(:,i)==1);
fv_pos{i}=[];

name_pos_single=cell(1);
for j=1:1:length(idx)
    file_name=fullfile(fv_dir,file_stems{idx(j),1});
    file_name=[file_name,'.mat'];
    if exist(file_name,'file')
    fv=read_fv_from_file(file_name);
    fv_pos{i}=[fv_pos{i},fv];
    name_pos_single{j}=file_stems{idx(j)};
    end
end
empties = find(cellfun(@isempty,name_pos_single));  % identify the empty cells
name_pos_single(empties) = []   ;                   % remove the empty cells
name_pos{i}=name_pos_single;
end

dim=109056;


%sub step 2 : get the only the threads with more than one
file_stems_stem=cellfun(@(x) x(1:end-4),file_stems,'uniformoutput',false);
for i=1:1:12
   name_single=name_pos{i};
%    name_single=name_single(:);
   name_single=cellfun(@(x) x(1:end-4),name_single,'uniformoutput',false);
   name_single_ui=unique(name_single);save()
%    fv=zeros(dim,length(name_single_ui));
fv=[];
idxx=1;
   for j=1:1:length(name_single_ui)
       idx=find(ismember(name_single,name_single_ui{j}));
       idxx2=find(ismember(file_stems_stem,name_single_ui{j}));
       if length(idx)>1 && length(idx)<length(idxx2)
       fv(:,idxx)=sum(fv_pos{i}(:,idx),2);  
       idxx=idxx+1;
       end
   end
   fv_pos_multi{i}=fv;
end

