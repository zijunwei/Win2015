% iteratively update models based on current model and new incoming
classdef svms_v2
    properties(Constant)
        sigular_thres=1e-16;
        dim=109056;
        it=1;
    end;
    methods(Static)
        % iterative both, start from the postive sum up and negative sum up
        function aps = kerLSSVM_singleCate_iterative1(Lambda, trD, trLb_i, tstD, tstLb,fv_info,num_threads)
            trK = trD*trD';
            trLb_i(trLb_i == 0) = -1;
            tstLb(tstLb == 0) = -1;
            n=length(trLb_i);
            s=ones(n,1)/(n);
            Lambda0=Lambda*n;
            [alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_i',Lambda0,s);
            
            
            
            % step0: generate a cell array of trD the idx is the id of data and
            % each cell may contain serverl threads later:
            % preserves the 1 threads
            % get id's of positive videos and negative videos that contains more than one threads.
            % We are going to add/replace fisher vectors provided that they do not make the total training
            % degenerate.
            
            % step 1: find the id's of video that contains more than one
            % threads
            % idxP: the location of positive video that contains more than 1 threads in
            % fv_info
            % idxPA: the location of positive videos that contains more than 1 threads
            % in trD
            % idxPAC  the location of positive videos that contains exactly 1 threads
            % in trD
            [idxP,idxPA,idxPAC]=svms.find_vid(1,num_threads,trLb_i);
            [idxN,idxNA,idxNAC]=svms.find_vid(-1,num_threads,trLb_i);
            P_info=fv_info(trLb_i==1);
            N_info=fv_info(trLb_i==-1);
            
            
            trPs=cell2mat([P_info(idxPAC).fv]);
            trNs=cell2mat([N_info(idxNAC).fv]);
            
            trPlbs=ones(size(trPs,2),1);
            trNlbs=-1*ones(size(trNs,2),1);

            newtrD=trD';
            for iit=1:1:svms.it
                % form new positive traning data from videos contain more than 1
                % thread
                for i=1:1:length(idxP)
                    
                    aug_fv=cell2mat([P_info(idxPA(i)).fv]);
                    scores=aug_fv'*newtrD*alphas+b;
                    [~,ii]=sort(scores,'descend'); % the smaller the score, the more likely to be a support vector for positive data
                    for jj=2:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDP{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                    end
                    
                end
                
                
                % form new negative training data from videos contain mroe than 1 thread
                for i=1:1:length(idxN)
                    aug_fv=cell2mat([N_info(idxNA(i)).fv]);
                    
                    scores=aug_fv'*newtrD*alphas+b;
                    [~,ii]=sort(scores,'descend');
                    for jj=1:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDN{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                        
                    end
                    
                end
                
                
                trPc=cell2mat(ctrDP);
                trNc=cell2mat(ctrDN);
                newtrD=[trPs,trNs,trPc,trNc];
                newtrLb=[trPlbs;trNlbs;ones(size(trPc,2),1);-1*ones(size(trNc,2),1)];
                
                trK=newtrD'*newtrD;
                n=length(newtrLb);
                s=ones(n,1)/(n);
                Lambda0=Lambda*n;
                [alphas,b]=ML_Ridge. kerRidgeReg(trK,newtrLb,Lambda0,s);
                
                
                
            end
            
            % iteration ends here
            
            tstK=tstD*newtrD;
            prob=tstK*alphas+b;
            aps= ml_ap(prob, tstLb, 0);
            
        end
        
        
        % the same as kerLSSVM_singleCate_iterative1 but chage the kerRidge
        % to loocv version
        function aps = kerLSSVM_singleCate_cv(Lambda, trD, trLb_i, tstD, tstLb,fv_info,trLb_raw,num_threads,trD_raw)
            trK = trD_raw*trD_raw';
            trLb_i(trLb_i == 0) = -1;
            tstLb(tstLb == 0) = -1;
            n=length(trLb_raw);
            s=ones(n,1)/(n);
            Lambda0=Lambda*n;
            [alphas,b,~,alphas_cv,b_cv]=ML_Ridge. ridgeReg_cv(trK,trLb_raw',Lambda0,s);
            
            
            
            % step0: generate a cell array of trD the idx is the id of data and
            % each cell may contain serverl threads later:
            
            % preserves the 1 threads
            
            
            
            % get id's of positive videos and negative videos that contains more than one threads.
            % We are going to add/replace fisher vectors provided that they do not make the total training
            % degenerate.
            
            % step 1: find the id's of video that contains more than one
            % threads
            % idxP: the location of positive video that contains more than 1 threads in
            % fv_info
            % idxPA: the location of positive videos that contains more than 1 threads
            % in trD
            % idxPAC  the location of positive videos that contains exactly 1 threads
            % in trD
            [idxP,idxPA,idxPAC]=svms.find_vid(1,num_threads,trLb_raw);
            [idxN,idxNA,idxNAC]=svms.find_vid(-1,num_threads,trLb_raw);
            P_info=fv_info(trLb_raw==1);
            N_info=fv_info(trLb_raw==-1);
            
            
            trPs=cell2mat([P_info(idxPAC).fv]);
            trNs=cell2mat([N_info(idxNAC).fv]);
            
            trPlbs=ones(size(trPs,2),1);
            trNlbs=-1*ones(size(trNs,2),1);
            
            
            
            
            
            for iit=1:1:svms.it
                % form new positive traning data from videos contain more than 1
                % thread
                for i=1:1:length(idxP)
                    
                    aug_fv=cell2mat([P_info(idxPA(i)).fv]);
                    scores=aug_fv'*trD_raw'*alphas_cv(:,idxP(i))+b_cv(idxP(i));
                    [~,ii]=sort(scores,'ascend'); % the smaller the score, the more likely to be a support vector for positive data
                    for jj=2:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDP{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                    end
                    
                end
                
                
                % form new negative training data from videos contain mroe than 1 thread
                for i=1:1:length(idxN)
                    aug_fv=cell2mat([N_info(idxNA(i)).fv]);
                    
                    scores=aug_fv'*trD_raw'*alphas_cv(:,idxN(i))+b_cv(idxN(i));
                    [~,ii]=sort(scores,'descend');
                    for jj=1:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDN{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                        
                    end
                    
                end
                
                
                trPc=cell2mat(ctrDP);
                trNc=cell2mat(ctrDN);
                newtrD=[trPs,trNs,trPc,trNc];
                newtrLb=[trPlbs;trNlbs;ones(size(trPc,2),1);-1*ones(size(trNc,2),1)];
                
                trK=newtrD'*newtrD;
                n=length(newtrLb);
                s=ones(n,1)/(n);
                Lambda0=Lambda*n;
                [alphas,b]=ML_Ridge. kerRidgeReg(trK,newtrLb,Lambda0,s);
                
                
                
            end
            
            % iteration ends here
            
            tstK=tstD*newtrD;
            prob=tstK*alphas+b;
            aps= ml_ap(prob, tstLb, 0);
            
        end
        
        
        % This function fixes the positive data. Uses the baseline to start
        % the iteration
        % ONLY iterate over the negative data
        
        function aps = kerLSSVM_singleCateFP(Lambda,trD_raw, trLb_raw,tstD, tstLb,fv_info,num_threads)
            trK = trD_raw*trD_raw';
            trLb_raw(trLb_raw==0)=-1;
            tstLb(tstLb == 0) = -1;
            n=length(trLb_raw);
            s=ones(n,1)/(n);
            Lambda0=Lambda*n;
            [alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_raw',Lambda0,s);
            
            
            
            % step0: generate a cell array of trD the idx is the id of data and
            % each cell may contain serverl threads later:
            
            % preserves the 1 threads
            
            
            
            % get id's of positive videos and negative videos that contains more than one threads.
            % We are going to add/replace fisher vectors provided that they do not make the total training
            % degenerate.
            
            % step 1: find the id's of video that contains more than one
            % threads
            % idxP: the location of positive video that contains more than 1 threads in
            % fv_info
            % idxPA: the location of positive videos that contains more than 1 threads
            % in trD
            % idxPAC  the location of positive videos that contains exactly 1 threads
            % in trD
            %             [idxP,idxPA,idxPAC]=svms.find_vid(1,num_threads,trLb_raw);
            [idxN,idxNA,idxNAC]=svms.find_vid(-1,num_threads,trLb_raw);
            P_info=fv_info(trLb_raw==1);
            N_info=fv_info(trLb_raw==-1);
            
            % use all the positive data
            %trPs=cell2mat([P_info.fv{1}]);
            trPs=trD_raw(trLb_raw==1,:);
            trNs=cell2mat([N_info(idxNAC).fv]);
            
            trPlbs=ones(size(trPs,1),1);
            trNlbs=-1*ones(size(trNs,2),1);
            
            
            
            newtrD=trD_raw';
            
            
            for iit=1:1:svms.it
               
                
                
                % form new negative training data from videos contain mroe than 1 thread
                for i=1:1:length(idxN)
                    aug_fv=cell2mat([N_info(idxNA(i)).fv]);
                    
                    scores=aug_fv'*newtrD*alphas+b;
                    [~,ii]=sort(scores,'descend');
                    for jj=1:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDN{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                        
                    end
                    
                end
                
                
                trNc=cell2mat(ctrDN);
                newtrD=[trPs',trNs,trNc];
                newtrLb=[trPlbs;trNlbs;-1*ones(size(trNc,2),1)];
                
                trK=newtrD'*newtrD;
                n=length(newtrLb);
                s=ones(n,1)/(n);
                Lambda0=Lambda*n;
                [alphas,b]=ML_Ridge. kerRidgeReg(trK,newtrLb,Lambda0,s);
                
                
                
            end
            
            % iteration ends here
            
            tstK=tstD*newtrD;
            prob=tstK*alphas+b;
            aps= ml_ap(prob, tstLb, 0);
            
        end
        
        
        % This function fixes the positive data. Uses the baseline to start
        % the iteration
        % ONLY iterate over the negative data
        
        function aps = kerLSSVM_singleCateFN(Lambda,trD_raw, trLb_raw,tstD, tstLb,fv_info,num_threads)
            trK = trD_raw*trD_raw';
            trLb_raw(trLb_raw==0)=-1;
            tstLb(tstLb == 0) = -1;
            n=length(trLb_raw);
            s=ones(n,1)/(n);
            Lambda0=Lambda*n;
            [alphas,b]=ML_Ridge. ridgeReg(trK,trLb_raw',Lambda0,s);
            
            
            
            % step0: generate a cell array of trD the idx is the id of data and
            % each cell may contain serverl threads later:
            
            % preserves the 1 threads
            
            
            
            % get id's of positive videos and negative videos that contains more than one threads.
            % We are going to add/replace fisher vectors provided that they do not make the total training
            % degenerate.
            
            % step 1: find the id's of video that contains more than one
            % threads
            % idxP: the location of positive video that contains more than 1 threads in
            % fv_info
            % idxPA: the location of positive videos that contains more than 1 threads
            % in trD
            % idxPAC  the location of positive videos that contains exactly 1 threads
            % in trD
            [idxP,idxPA,idxPAC]=svms.find_vid(1,num_threads,trLb_raw);
            [idxN,idxNA,idxNAC]=svms.find_vid(-1,num_threads,trLb_raw);
            P_info=fv_info(trLb_raw==1);
            N_info=fv_info(trLb_raw==-1);
            
            % use all the positive data
            % %trPs=cell2mat([P_info.fv{1}]);
            trNs=trD_raw(trLb_raw==-1,:);
            trPs=cell2mat([P_info(idxPAC).fv]);
            
            trPlbs=ones(size(trPs,2),1);
            trNlbs=-1*ones(size(trNs,1),1);
            
            
            
            
            newtrD=trD_raw';
            for iit=1:1:svms.it
                % form new positive traning data from videos contain more than 1
                % thread
                for i=1:1:length(idxP)
                    
                    aug_fv=cell2mat([P_info(idxPA(i)).fv]);
                    scores=aug_fv'*newtrD*alphas+b;
                    [~,ii]=sort(scores,'descend'); % the smaller the score, the more likely to be a support vector for positive data
                    for jj=2:1:length(ii)
                        if Zj_MatrixChecking.iscondition(aug_fv(:,ii(1:jj))'*aug_fv(:,ii(1:jj)))|| jj==length(ii)
                            
                            
                            ctrDP{i}=aug_fv(:,ii(1:jj-1));
                            break;
                            
                            
                            
                        end
                    end
                    
                end
                
                
               
              
                
                trPc=cell2mat(ctrDP);
                %trNc=cell2mat(ctrDN);
                newtrD=[trPs,trNs',trPc];
                newtrLb=[trPlbs;trNlbs;1*ones(size(trPc,2),1)];
                
                trK=newtrD'*newtrD;
                n=length(newtrLb);
                s=ones(n,1)/(n);
                Lambda0=Lambda*n;
                [alphas,b]=ML_Ridge. kerRidgeReg(trK,newtrLb,Lambda0,s);
                
                
                
            end
            
            % iteration ends here
            
            tstK=tstD*newtrD;
            prob=tstK*alphas+b;
            aps= ml_ap(prob, tstLb, 0);
            
        end
        
        % this function is used to find the id of positve/negative videos that
        % contains more than 1 thread
        function [idx,idxa,idxac]=find_vid(pn,num_threads,trLb_raw)
            
            idn=find(trLb_raw==pn);
            pos_num_threads=num_threads(idn);
            tmp= pos_num_threads>1;
            idxa=find(tmp==1);
            idxac=find(tmp==0);
            idx=idn(tmp);
        end
        
        
        
    end
end