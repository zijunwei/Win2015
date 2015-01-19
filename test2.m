%tst2 : test on annotated data
%AnswerPhoneGT=csvread('threadclassification_AnswerPhone.csv');
AnswerPhoneGT='threadclassification_AnswerPhone.csv';

 %fid = fopen(AnswerPhoneGT);
 
%  C= textscan(fid,'%s%d',1,'delimiter',',');
%  fclose(fid);
% %C=cell2struct(C,{'fname','label'},2);

lineArray=read_mixed_csv(AnswerPhoneGT,',');

%positive data:
%load positive examples:



% positive examples:
idx=find(x==1);
fv_all=[];

fv_dir='./DataFromServer/fv_thread';
for i=1:1:length(idx)
    file_name=fullfile(fv_dir,lineArray{idx(i),1});
    file_name=[file_name(1:end-4),'mat'];
    if exist(file_name,'file')
    fv=read_fv_from_file(file_name);
    fv_all=[fv_all,fv];
    end
end