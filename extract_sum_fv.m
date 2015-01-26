% extract only the sum of all fisher vectors from structure fv_info
function outD=extract_sum_fv(fv_info)
dim=109056;
num_threads=length(fv_info);
outD=zeros(dim,num_threads);

slots=[1,7680,24576,27648,49152];


for i=1:1:num_threads
    outD(:,i)= sum( fv_info(i).fv{1},2);
    
end

fv_sub=cell(4,1);
for i=1:1:length(slots)-1
    start_idx=sum( slots(1:i));
    end_idx=sum(slots(1:i+1))-1;
    fv_sub{i}=outD(start_idx:end_idx,:);
    fv_sub{i}=Zj_Normalization.power2(fv_sub{i});
end

outD=[fv_sub{1};fv_sub{2};fv_sub{3};fv_sub{4}];

outD=Zj_Normalization.l2(outD');
outD=outD';
end

