% experiment prep obselete
% extract thread video
% positive data: sum up of all positive threads in a video. i.e the first
%                item in fv_arg
% negative data: all single threads in negative data


clear;
Init;
load('clipset_mac.mat');

load('fv_struct.mat');

fv_dim=109056;

 allnames={fv_struct.filename};

for idx=1:1:length(classTxt)
fprintf('processing %s \n',classTxt{idx});
refinfo=read_clipsets(training_clipset{idx});

% for positive data, get the fv from the sum of all
pos_lb=find(refinfo.label==1);
% preallocate
pos_fv=zeros(length(pos_lb),fv_dim);
for i=1:1:length(pos_lb)

    filepattern=refinfo.fname{pos_lb(i)};
    ind=strfind(allnames,filepattern);
    index  = find(~cellfun(@isempty,ind));
    fv=sum(  [fv_struct(index).fv],2);
    pos_fv(i,:)=fv';
    
end

%extracting negative data speeding up, prealocate storage
neg_lb=find(refinfo.label==-1);

neg_idx=[];
for i=1:1:length(neg_lb)
       filepattern=refinfo.fname{neg_lb(i)};
       ind=strfind(allnames,filepattern);
       index  = find(~cellfun(@isempty,ind));
       neg_idx=[neg_idx,index];
end
neg_fv=zeros(length(neg_idx),fv_dim);

for i=1:1:length(neg_idx)
        tmp_fv=fv_struct(neg_idx(i)).fv;
        neg_fv(i,:)=tmp_fv';
     
    
end
trD=[pos_fv;neg_fv];
trD=Zj_Normalization.l2(trD);
trLb=[ones(1,size(pos_fv,1)),-1*ones(1,size(neg_fv,1))];


save(sprintf('%s_psni_l2.mat',classTxt{idx}),'trD','trLb','-v7.3');
end
