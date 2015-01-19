% iteratively update models based on current model and new incoming
classdef svms
    properties(Constant)
        sigular_thres=1e-16;
    end;
    methods(Static)
function aps = kerLSSVM_singleCate_iterative(Lambda, trD, trLb_i, tstD, tstLb,fv_info,trLb_raw,num_threads)
    trK = trD*trD';
    tstK = tstD*trD';
    
    
    
    % step0: generate a cell array of trD the idx is the id of data and
    % each cell may contain serverl threads later:
    
    ctrD=num2cell(trD,2);
    
        % get id's of positive videos and negative videos that contains more than one threads. 
        % We are going to add/replace fisher vectors provided that they do not make the total training
        % degenerate. 
        
        % step 1: find the id's of video that contains more than one
        % threads
        % idxP: the location of video that contains more than 1 threads in
        % training data
        % idxPA: the location of videos that contains more than 1 threads
        % in trD
        [idxP,idxPA]=svms.find_vid(1,num_threads,trLb_raw);
        [idxN,idxNA]=svms.find_vid(-1,num_threads,trLb_raw);
       
        % 1st model calculated:
        trLb_i(trLb_i == 0) = -1;
        tstLb(tstLb == 0) = -1;                
        n=length(trLb_i);
        s=ones(n,1)/(n);
        Lambda0=Lambda*n;
        [alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_i,Lambda0,s);
          
        cur_scores=trK*alphas+b;
        % for positive data: adding 
        
        for i=1:1:length(idxP)
            cur_fv=  ctrD{idxPA(i)};
            aug_fv=[fv_info(idxP(i)).fv{1:end}];
            cur_score=cur_scores(idxPA(i));
            scores=aug_fv'*trD'*alphas+b;
            [~,ii]=sort(scores,'ascend'); % the smaller the score, the more likely to be a support vector
            for jj=1:1:length(ii)
               if scores(jj)>cur_score && ~Zj_MatrixChecking.iscondition([cur_fv;aug_fv(:,jj)'])
                   ctrD{idxPA(i)}=[ctrD{idxPA(i)};aug_fv(:,jj)'];
               end
            end
            
        end
        
        % for negative data :replacing
        
        for i=1:1:length(idxN)
            
            aug_fv=[fv_info(idxN(i)).fv];
            scores=aug_fv'*trD'*alphas+b;
            [~,ii]=sort(scores,'descend');
            for jj=1:1:length(ii)
               if  ~Zj_MatrixChecking.iscondition(aug_fv(:,1:jj)')
                   continue;
               else
                   ctrD{idxNA(i)}=aug_fv(:,1:jj-1)';
               end
               
               
            end
            
        end
        
        
        
        prob=tstK*alphas+b;
        aps= ml_ap(prob, tstLb, 0);
   
end
% this function is used to find the id of positve/negative videos that
% contains more than 1 thread
function [idx,idxa]=find_vid(pn,num_threads,trLb_raw)

        idn=find(trLb_raw==pn);
        pos_num_threads=num_threads(idn);
        tmp= pos_num_threads>1;
        idxa=find(tmp==1);
        idx=idn(tmp);
end
    end
end