% this is used to check if the annotaitons are all right


load('annotation_info.mat');

load('trVideoNames.mat');
load('H2_rawtrLb');

classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};
for i=1:1:12
rawtrLb_i=raw_trLb(i,:);
Anno_i=Anno(:,i);
idx_raw=find(rawtrLb_i==1);
idx_thread=find(Anno_i==1);

names_raw=VideoNames(idx_raw);
names_thread=file_stems(idx_thread);


%test one correspondences:
for j=1:1:length(names_raw)
    res=strfind(names_thread,names_raw{j});
    if isempty(find(~cellfun(@isempty,res)))
       warning('%s doesn''t have corresponding thread in cate %s!\n',names_raw{j},classTxt{i}); 
       
    end
    
end

% test another correspondencesL
for j=1:1:length(names_thread)
    res=strfind(names_raw,names_thread{j}(1:end-4));
    if isempty(find(~cellfun(@isempty,res)))
       warning('%s doesn''t have corresponding thread in cate %s!\n',names_thread{j},classTxt{i}); 
       
    end
    
end

end