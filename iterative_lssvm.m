% this function iteratively update the traning examples based on the scores
function [alpha,b,trD]=iterative_lssvm(Lambda,trD,trLb,arg_fv,pos_ind)
% tst Kernel can be done only once outside



%[A B]*[A,B]'=[AA, AB
%              AB, BB]

trLb(trLb == 0) = -1;
trK=trD*trD';
idx=1;
n=length(trLb);
Lambda0=Lambda*n;
while(1)
    fprintf('training LSSVM model  iteration %d\n', idx);
    
    
    s=ones(n,1)/(n);
    
    isCond=Zj_MatrixChecking.iscondition(trK);
    if isCond
        warning('At iteration %d, the kernel matrix is problematic\n',idx);
    end
    [alpha,b]=ML_Ridge.kerRidgeReg(trK,double(trLb)',Lambda0,s);
    [trD_update,arg_fv]=validation(arg_fv,alpha,b,pos_ind,trD);
    if ~isempty(trD_update)
        trK=[trK,trD*trD_update';trD_update*trD',trD_update*trD_update'];
        trLb=[trLb,ones(1,size(trD_update,1))];
        trD=[trD;trD_upadte];
    else
        break;
    end
    idx=idx+1;
end;


end

function [new_samples,arg_fv]=validation(arg_fv,alpha,b,pos_ind,trD)
new_samples=[];
for i=1:1:length(pos_ind)
    sub_sample=[];
    
    for j=1:1:length(arg_fv(pos_ind(i)).fv)
        sub_sample=[sub_sample;arg_fv(pos_ind(i)).fv{j}];
    end
    
    sub_sample=Zj_Normalization.l2(sub_sample);
    s_scores=alpha'*(trD*sub_sample')+b;
    [~,idx]=max(s_scores);
    if idx~=1 && ~Zj_MatrixChecking.isrow(sub_sample(idx,:),trD)
        
        new_samples=[new_samples;sub_sample(idx,:)];
    end
end
end