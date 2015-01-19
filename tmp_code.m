% tmp_code
clc;
i=12;
rawtrLb_i=raw_trLb(i,:);
Anno_i=Anno(:,i);
idx_raw=find(rawtrLb_i==1);
idx_thread=find(Anno_i==1);

names_raw=VideoNames(idx_raw);
names_thread=file_stems(idx_thread);



for j=1:1:length(names_raw)
    res=strfind(names_thread,names_raw{j});
    if isempty(find(~cellfun(@isempty,res)))
       warning('%s doesn''t have corresponding thread in cate %s!\n',names_raw{j},classTxt{i}); 
       
    end
    
end
idx_raw'
classTxt{i}
