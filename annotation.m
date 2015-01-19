% annotation helper
for i=1:1:length(classTxt)
    
   fprintf('%s \n',classTxt{i}); 
end

video_dir='./DataFromServer/fv_shotboundary';
files=dir(fullfile(video_dir,'*.avi'));

for i=1:1:size(raw_trLb,1)
   idx{i}=find(raw_trLb(i,:)==1); 
end

sz=0;
for i=1:1:size(idx,2)
    sz=sz+  length(idx{i});
end