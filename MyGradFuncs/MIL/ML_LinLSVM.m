classdef ML_LinLSVM
    % Linear Latent SVM. 
    
    methods (Static)
        % posD, negD: d*nPos, d*nNeg matrices
        % nMixture: # of components for postive data
        % C: C value for linear SVM
        function model = train(posD, negD, nMixture, C)            
            % Initialization with k-means
            Cs = vgg_kmeans(posD, nMixture, 'maxiters', inf, 'mindelta', eps, 'verbose', 0);
            
            % Learn one weight vector for each cluster
            parm.posD = mat2cell(posD, size(posD,1), ones(1, size(posD,2)));
            parm.negD = mat2cell(negD, size(negD,1), ones(1, size(negD,2)));
            parm.C = C;
            parm.dimension = size(posD,1); 
            parm.nMixture = nMixture;
            parm.initWs = {Cs};
            parm.initBs = {-0.5*sum(Cs.^2)}; % k-means maximize -0.5*||c - x||^2, so the bias is -0.5*||c||^2
            parm.featureFn = @ML_LinLSVM.featureFn;             
            parm.verbose = 1;
            model = ml_MCMISVM_cplex(parm);            
            fprintf('sum(xi): %.3f\n', sum(model.xi(:))); 

        end
        
        function [mixtureIDs, scores] = predict(D, model)
            mixtureIDs = zeros(1, size(D,2));
            scores = zeros(1, size(D,2));
            for i=1:size(D,2)
                [mixtureIDs(i), scores(i)] = ML_LinLSVM.predict_helper(D(:,i), model);
            end;
            
        end
        
        function [mixtureID, bestScore] = predict_helper(x, model)
            score = model.Ws'*x + model.bs(:);
            [bestScore, mixtureID] = max(score);             
        end
        
        function [desc, mixtureID, score] = featureFn(model, parm, x)
            desc = x;
            [mixtureID, score] = ML_LinLSVM.predict_helper(x, model); 
        end;
        
       
    end
    
end

