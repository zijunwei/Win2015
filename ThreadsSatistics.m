% this function gives some threads satistics:
% like:
%    average threads of all 823 training videos

clear;
clc;
load('annotation_info.mat');

load('trVideoNames.mat');
load('H2_rawtrLb');

classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};


% counting how many threads each video contains:(mean,variance)
counter=zeros(length(VideoNames),1);
for i=1:1:length(VideoNames)
    res=strfind(file_stems,VideoNames{i});
    counter(i)=sum(~(cellfun(@isempty,res)));
    
end
% median, var, mean,histogram



% counting average threads per video contains regarding to different
% actions
% counter_sub(i,:): number of threads each video belonging to cat i
% contains

% this is used to count how many threads count for an action, for example,
% kissing may occur at 2 threads at one action video, the value is 2.

% for i=1:1:12
%     
%     rawtrLb_i=raw_trLb(i,:);
%     Anno_i=Anno(:,i);
%     idx_raw=find(rawtrLb_i==1);
%     idx_thread=find(Anno_i==1);
%     
%     names_raw=VideoNames(idx_raw);
%     names_thread=file_stems(idx_thread);
%     
%     cate(i).name=classTxt{i};
%     %test one correspondences:
%     cate(i).num=zeros(length(names_raw),1);
%     for j=1:1:length(names_raw)
%         res=strfind(names_thread,names_raw{j});
%         cate(i).num(j) = sum(~cellfun(@isempty,res));
%     end
%     
%     cate(i).mean=mean(cate(i).num);
%     cate(i).var=var(cate(i).num);
%     cate(i).median=median(cate(i).num);
% end

for i=1:1:12
    
    rawtrLb_i=raw_trLb(i,:);
    Anno_i=Anno(:,i);
    idx_raw=find(rawtrLb_i==1);
    idx_thread=find(Anno_i==1);
    
    names_raw=VideoNames(idx_raw);
    names_thread=file_stems(idx_thread);
    
    threadperaction(i).name=classTxt{i};
    %test one correspondences:
    threadperaction(i).num=zeros(length(names_raw),1);
    for j=1:1:length(names_raw)
        res=strfind(file_stems,names_raw{j});
        threadperaction(i).num(j) = sum(~cellfun(@isempty,res));
    end
    
    threadperaction(i).mean=mean(threadperaction(i).num);
    threadperaction(i).var=var(threadperaction(i).num);
    threadperaction(i).median=median(threadperaction(i).num);
end

%
% for i=1:1:12
% rawtrLb_i=raw_trLb(i,:);
% Anno_i=Anno(:,i);
% idx_raw=find(rawtrLb_i==1);
% idx_thread=find(Anno_i==1);
%
% names_raw=VideoNames(idx_raw);
% names_thread=file_stems(idx_thread);
%
%
% %test one correspondences:
% for j=1:1:length(names_raw)
%     res=strfind(names_thread,names_raw{j});
%     if isempty(find(~cellfun(@isempty,res)))
%        warning('%s doesn''t have corresponding thread in cate %s!\n',names_raw{j},classTxt{i});
%
%     end
%
% end
%
% % test another correspondencesL
% for j=1:1:length(names_thread)
%     res=strfind(names_raw,names_thread{j}(1:end-4));
%     if isempty(find(~cellfun(@isempty,res)))
%        warning('%s doesn''t have corresponding thread in cate %s!\n',names_thread{j},classTxt{i});
%
%     end
%
% end
%
% end