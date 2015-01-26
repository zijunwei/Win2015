%    get the negative threads hidding in the positive videos

clear;
load('annotation_info.mat');

load('trVideoNames.mat');
load('H2_rawtrLb');
fv_dir='./DataFromServer/fv_thread';
for i=1:1:12
    idx=find(Anno(:,i)==1);
    pos_names_td=file_stems(idx);
    pos_names_vd=VideoNames(find(raw_trLb(i,:)==1));
    fv_neg{i}=[];
    fv_ng=[];
    for j=1:1:length(pos_names_vd)
        
        
        all_sub_thread_id=strmatch(pos_names_vd{j},file_stems);
        all_sub_thread=file_stems(all_sub_thread_id);
        
        for k=1:1:length(all_sub_thread)
            % kth threads is not in positive table
            if isempty(find(ismember(pos_names_td,all_sub_thread{k}))) 
                file_name=fullfile(fv_dir,[all_sub_thread{k},'.mat']);
                fv_all=[];
                if exist(file_name,'file')
                    fv=read_fv_from_file(file_name);
                    fv_all=[fv_all,fv];
                end
                
            end
            
        end
        fv=sum(fv_all,2);
        fv_ng=[fv_ng,fv];
    end
    fv_neg{i}=fv_ng;
end

% dim=109056;
%
%
% %sub step 2 : get the only the threads with more than one
% file_stems_stem=cellfun(@(x) x(1:end-4),file_stems,'uniformoutput',false);
% for i=1:1:12
%    name_single=name_pos{i};
% %    name_single=name_single(:);
%    name_single=cellfun(@(x) x(1:end-4),name_single,'uniformoutput',false);
%    name_single_ui=unique(name_single);save()
% %    fv=zeros(dim,length(name_single_ui));
% fv=[];
% idxx=1;
%    for j=1:1:length(name_single_ui)
%        idx=find(ismember(name_single,name_single_ui{j}));
%        idxx2=find(ismember(file_stems_stem,name_single_ui{j}));
%        if length(idx)>1 && length(idx)<length(idxx2)
%        fv(:,idxx)=sum(fv_neg{i}(:,idx),2);
%        idxx=idxx+1;
%        end
%    end
%    fv_pos_multi{i}=fv;
% end

