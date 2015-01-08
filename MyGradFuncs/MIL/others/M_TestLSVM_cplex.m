classdef M_TestLSVM_cplex
    methods (Static)        
        % Each bag has only one instance
        % Multiple components and each component is a Guassian.
        % The negative examples are also Gaussian
        function test2()            
            % Generate data
            
            nBin = 2;
            nSamplePerMixture = [10, 10, 10, 10, 10, 10];
            nNeg = 40;
            
            nRestart = 10;
            
            nMixture = length(nSamplePerMixture);
            
            centers = 10*randn(nBin, nMixture + 1);
            
            sigma = 0.1;
            posD = cell(1, nMixture);
            for i=1:nMixture
                posD{i} = repmat(centers(:,i),1, nSamplePerMixture(i)) + ...
                    sigma*randn(nBin, nSamplePerMixture(i));
            end;
            posD = cat(2, posD{:});
            negD = repmat(centers(:,end),1, nNeg) + 2*sigma*randn(nBin, nNeg).*repmat([4;1], 1, nNeg);
            
            
            parm.posD = mat2cell(posD, nBin, ones(1, size(posD,2)));
            parm.negD = mat2cell(negD, nBin, ones(1, size(negD,2)));
            parm.C = 1000;
            parm.dimension = nBin; % because of two-part segment
            parm.nMixture = nMixture;     
            parm.verbose = 3;

            
            parm.featureFn = @M_TestLSVM_cplex.featureFnForTest2; 

            for i=1:nRestart            
                parm.initWs{i} = randn(nBin, nMixture);
                parm.initBs{i} = zeros(1, nMixture);
            end
            model = ml_LSVM_cplex(parm);

            colors = {'.r', '*b', 'og', '.c', '*m', 'oy', '*r', '.b'};
            
            clf; scatter(negD(1,:), negD(2,:), '+k'); hold on; 
            
            clusterIdxs = zeros(1, size(posD,2));
            for i=1:size(posD,2)
                [~, clusterIdxs(i)] = M_TestLSVM_cplex.featureFnForTest2(model, parm, posD(:,i));
            end;
            for i=1:nMixture
                scatter(posD(1,clusterIdxs == i), posD(2,clusterIdxs == i), colors{i}); 
            end
            axis image;
            
            fprintf('sum(xi): %.3f\n', sum(model.xi));
        end;
        
        function [desc, mixtureID] = featureFnForTest2(model, parm, x)
            desc = x;
            score = model.Ws'*x + model.bs(:);
            [~, mixtureID] = max(score); 
        end;
        
        
        
        % Only two bags, each bag contains a single instance
        function test1()
            nMixture = 1;            
            nBin = 2;            
            parm.posD = {randn(nBin,1)}; 
            parm.negD = {randn(nBin,1)};
            parm.C = 1000;
            parm.dimension = nBin; % because of two-part segment
            parm.nMixture = 1;
            parm.initWs = {randn(nBin, nMixture)};
            parm.initBs = {zeros(1, nMixture)};
            parm.featureFn = @M_TestLSVM_cplex.featureFnForTest1;                                   
            parm.verbose = 5;
                        
            model = ml_LSVM_cplex(parm);
            
            w_exp = parm.posD{1} - parm.negD{1};
            w_exp = 2/sum(w_exp.^2)*w_exp;
            b_exp = 1 - w_exp'*parm.posD{1};
            fprintf('Expected w, b: '); fprintf('%.3f ', [w_exp; b_exp]); fprintf('\n');            
            fprintf('Returned w, b: '); fprintf('%.3f ', [model.Ws; model.bs]); fprintf('\n');                        
            fprintf('xi: '); fprintf('%.3f ', model.xi); fprintf('\n');
            if sum((w_exp - model.Ws).^2) > 0.1
                error('test1: mismatch between the expected and the returned values');
            end;            
        end;
        
        function [desc, mixtureID] = featureFnForTest1(model, parm, x)
            desc = x;
            mixtureID = 1;            
        end;
    end
end