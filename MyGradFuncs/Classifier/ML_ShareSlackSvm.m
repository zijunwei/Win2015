classdef ML_ShareSlackSvm
% By: Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Created: 02-Aug-2013
% Last modified: 02-Aug-2013    
    
    methods (Static)                
        % wrapper around linearSvm_nobias for bias term
        % Note: the returned dual and primal objectives correspond to regularized bias
        function [w, b, varargout] = linearSvm(D, varargin)
            mD = mean(D, 2);
            D = D - repmat(mD, 1, size(D,2)); % subtract the mean to avoid big bias term due to 
                                              % large translation displacement
            
            appVal = mean(sqrt(sum(D.^2,1))); % mean L2 norms
                                              % If this value is small, this discourges large bias,
                                              % which can affects the classification performance if
                                              % data is not well-centered.
                                              % If this value is big, the optimization is
                                              % ill-behaved. This is set to mean L2 norm so that the
                                              % regularization of ||w|| is roughly as the
                                              % regularization for b.
            D(end+1,:) = appVal; % for the bias term

            nout = max(nargout,1) - 2;
            outs = cell(1, nout);            
            [w, outs{:}] = ML_ShareSlackSvm.linearSvm_nobias(D, varargin{:});
            for i=1:nout
                varargout{i} = outs{i}; %#ok<AGROW>
            end;
            b = w(end)*appVal;
            w = w(1:end-1);
            b = b - mD'*w;
        end
        
        % D:  d*n data matrix for n data points
        % lb: n*1 label vector of 1, -1
        % slackGrp: a 1*m cell structure for m group of data ids.
        %   slackGrp{i} is the ids of data points that share the same slack variable        
        %   Positive data and negative data points can share the same slack variable
        %   For computation reason, it is better not to have group of with a single id        
        %   A data point does not have to be in a group (ie., a single slack for its own).
        %   A data point cannot belong two two groups
        %       e.g., slackGrp = {}, all data points have separate slack
        %       e.g., slackGrp = {[2,3,10]}, points 2, 3, 10 have the same slack
        % C: either a positive scalar or a n*1 positive vector
        %   C is the tradeoff for large margin and less constraint violation
        %   If C is n*1 vector, C(i) is associated with the tradeoff value for i^th data point
        %   Data points have the same slack variables must have the same value of C
        % Let IndSlacks = ids that do not belong to any of slackGrp{j}        
        % This function optimizes
        %   min_{w} 0.5*||w||^2 + sum_{i in IndSlacks} C_i*alpha_i 
        %                       + sum_{slack group j} C_grp_j*beta_j
        %    s.t   y_i*(w'*x_i) >= 1 - alpha_i for in in IndSlacks
        %          y_i*(w'*x_i) >= 1 - beta_j for all i in slackGrp{j}.
        %          alpha_i >= 0, beta_j >= 0
        % Note: there is no bias term, use linearSvm2 if you need bias term
        function [w, alpha, dualObj, primalObj, xi] = linearSvm_nobias(D, lb, slackGrp, C, optMethod, varargin)            
            K = D'*D;
            
            if strcmpi(optMethod, 'pqn')
                if nargout > 2
                    [alpha, dualObj] = ML_ShareSlackSvm.kernelSvm_PQN(K, lb, slackGrp, C, varargin{:});
                else
                    alpha = ML_ShareSlackSvm.kernelSvm_PQN(K, lb, slackGrp, C, varargin{:});
                end            
            elseif strcmpi(optMethod, 'cplex')
                [alpha, dualObj] = ML_ShareSlackSvm.kernelSvm_cplex(K, lb, slackGrp, C, varargin{:});
            else
                error('unknown optimization method');
            end;
            
            w = D*(alpha.*lb);
                        
            if nargout > 3 % compute the primal
                svmScore = D'*w;                
                xi = max(1 - lb.*svmScore, 0); 
                
                Cxi = C.*xi;                
                slgrCxi = zeros(1, length(slackGrp));
                for i=1:length(slackGrp)
                    slgrCxi(i) = max(Cxi(slackGrp{i}));
                end;
                
                % items not in any slack group
                nonSlgrMems = setdiff(1:length(lb), cat(2, slackGrp{:}));
                primalObj = 0.5*(w'*w) + sum(Cxi(nonSlgrMems)) + sum(slgrCxi);
            end
        end;
        
        
        
        % K: n*n kernel matrix
        % lb: n*1 label vector of 1, -1
        % slackGrp: a 1*m cell structure for m group of data ids.
        %   slackGrp{i} is the ids of data points that share the same slack variable        
        %   Positive data and negative data points can share the same slack variable
        %   For computation reason, it is better not to have group of with a single id        
        %   A data point does not have to be in a group (ie., a single slack for its own).
        %   A data point cannot belong two two groups
        %       e.g., slackGrp = {}, all data points have separate slack
        %       e.g., slackGrp = {[2,3,10]}, points 2, 3, 10 have the same slack
        % C: either a positive scalar or a n*1 positive vector
        %   C is the tradeoff for large margin and less constraint violation
        %   If C is n*1 vector, C(i) is associated with the tradeoff value for i^th data point
        %   Data points have the same slack variables must have the same value of C
        % options: options for minConf PQN optimization function
        %   options.verbose, default is 2
        %   options.optTol, optimal tolerance threshold, If any measure of progress or optimality falls below this threshold, the algorithm terminates. The default is .000001.
        %   options.maxIter, maximum number of times that the function can be evaluated. The default is 500.
        %   options.suffDec, sufficient decrease parameter in the Armijo condition. This value must be in the range (0,1), and the default is .0001.
        %   options.interp, Specifies whether (safeguarded) cubic polynomial interpolation will be used to set the step sizes in the line search. The default is 1, so cubic polynomial interpolation is used. Setting it to 0 will use step size halving in the line search.
        % This function optimizes:
        %   max_{alpha} sum_i alpha_i - 0.5*sum_ij y_i*alpha_i*k(i,j)*y_j*alpha_j
        %       s.t. 0 <= alpha_i <= C_i
        %            0 <= sum_j alpha_{slackGrp{k}(j)} <= C_{slackGrp{k}(1) \forall k
        % Note: there is no bias term.        
        % On my test for n = 823, 2*823, 4*823, 8*823, 16*832 the computational cost is linear in n
        %   takes approximately 4, 5, 7, 14s, 60s on the Macbook pro
        %   however, the complexity of computing K is quadractic in n.
        function [alpha, dualObj] = kernelSvm_PQN(K, lb, slackGrp, C, initAlpha, options, sanityCheck)
            % fprintf('ML_ShareSlackSvm.kernelSvm ...\n');
            % Set up objective function
            
            n = size(K,2);            
            if length(C) ~= n && length(C) ~= 1
                error('C must be a scalar or a vector of the same length as lb');
            elseif length(C) == 1
                C = repmat(C, length(lb), 1);
            end;
            
            if ~exist('initAlpha', 'var') || isempty(initAlpha)
                initAlpha = zeros(n, 1);
            end;
            
            if exist('sanityCheck', 'var') && sanityCheck == 1
                % check the input for consistency
                if length(lb) ~= n
                    error('length of lb is inconsistent with kernel matrix');
                end;
                
                grpMems = cat(2, slackGrp{:});
                uniqueGrpMems = unique(grpMems);
                if length(uniqueGrpMems) ~= length(grpMems)
                    error('a data point cannot belong to two slack groups');
                end;
                if ~isempty(uniqueGrpMems) && (uniqueGrpMems(1) < 1 || uniqueGrpMems(end) > n)
                    error('slack group members must be between 1 and n');
                end;
            end;
            
                                        
            if ~exist('options', 'var') || isempty(options);
                options = [];
                options.maxIter = 1000;
                options.verbose = 1;
            end;
                
            funObj  = @(alpha)dualSvmNegObj(alpha,K,lb);            
            funProj = @(alpha)dualSvmProject(alpha, C, slackGrp);            
            alpha = minConf_PQN(funObj,initAlpha,funProj,options);
                        
            if nargout > 1
                dualObj = - dualSvmNegObj(alpha, K, lb);
            end
        end;
        
        
        
        % Use cplex for optimization, see 
        function [alpha, dualObj] = kernelSvm_cplex(K, lb, slackGrp, C, initAlpha, sanityCheck, useBias)
            grLens = cellfun(@length, slackGrp);
            slackGrp = slackGrp(grLens > 1);
            
            n = size(K,2);    
            lb = lb(:);
            if length(C) ~= n && length(C) ~= 1
                error('C must be a scalar or a vector of the same length as lb');
            elseif length(C) == 1
                C = repmat(C, length(lb), 1);
            end;
            
            if exist('sanityCheck', 'var') && sanityCheck == 1
                % check the input for consistency
                if length(lb) ~= n
                    error('length of lb is inconsistent with kernel matrix');
                end;
                
                grpMems = cat(2, slackGrp{:});
                uniqueGrpMems = unique(grpMems);
                if length(uniqueGrpMems) ~= length(grpMems)
                    error('a data point cannot belong to two slack groups');
                end;
                if ~isempty(uniqueGrpMems) && (uniqueGrpMems(1) < 1 || uniqueGrpMems(end) > n)
                    error('slack group members must be between 1 and n');
                end;
            end;
            
            % variable x = [w; b; xi] = [w_1; ...; w_k; b_1;...; b_k; xi_1; ...; xi_n];
            cplex = Cplex('ML_ShareSlackSVM');
            cplex.Model.sense = 'maximize';            
            
            % Add linear part of the objective
            obj = ones(n,1);            
            
            % add to the objective: sum_i alpha_i
            % cplex.Model.obj = obj; % this syntax doesn't work, use the below
            cplex.addCols(obj);
            
            % Add to objective: - \sum_{ij} y_i*alpha_i*k(i,j)*y_j*alpha_j
            cplex.Model.Q = - (lb*lb').*K;
            
            % Add constraint: alpha_i >= 0                        
            cplex.Model.lb = zeros(n, 1);
            
            % Add constraint: alpha_i <= C_i            
            cplex.Model.ub = C;
            
            % Add a constraint for each slack group
            if ~isempty(slackGrp)
                constrVecs = zeros(length(slackGrp), n);
                C_grps = zeros(length(slackGrp), 1);
                for j=1:length(slackGrp)
                    slckGrp_j = slackGrp{j};
                    constrVecs(j,slckGrp_j) = 1;
                    C_grps(j) = C(slckGrp_j(1));
                end;
                cplex.addRows(-inf(length(slackGrp),1), constrVecs, C_grps);
            end
            
            if exist('useBias', 'var') && useBias == 1                
                % Add a constraint for the bias term: sum_i y_i*alpha_i = 0
                cplex.addRows(0, lb', 0);
            end
            
            % Initial solution
            if exist('initAlpha', 'var') && ~isempty(initAlpha)
                cplex.Start.x = initAlpha(:);
            end
            
            % Callback function for display
            %cplex.DisplayFunc = []; %@disp;
            
            % solve
            cplex.Param.threads.Cur = 1; % use a single thread
            cplex.solve();
            alpha = cplex.Solution.x;    
            dualObj = cplex.Solution.objval;                         
        end
    end    
end



% Negative of dual SVM loss (so we minimize instead of maximize) 
function [f,g] = dualSvmNegObj(alpha,K,y)
    yalpha = y.*alpha;
    Kyalpha = K*yalpha;
    f = 0.5*yalpha'*Kyalpha - sum(alpha); % value
    g = y.*Kyalpha - 1; % gradient
end

% get the projection of vector alpha on the constraints of dual SVM
% Constraints of dual SVMs:
%   alpha_i >= 0 for all i
%   alpha_i <= C_i, if i doesn't belong to a slack group
%   sum_{i in slackGrp{j}} alpha_i <= C_grp_j 
% alpha, C: n*1 vectors
function proj = dualSvmProject(alpha, C, slckGrp)
    proj = alpha;
    proj(alpha < 0) = 0;
    idxs = alpha > C;
    proj(idxs) = C(idxs);
    
    for j=1:length(slckGrp)
        slckGrp_j = slckGrp{j};
        C_grp_j = C(slckGrp_j(1)); % same-slack variables must have same C, take first one.        
        if sum(proj(slckGrp_j)) > C_grp_j % only need to adjust if sum constraints is violated
            alpha_grp_j = alpha(slckGrp_j);
            idxs = alpha_grp_j > 0;
            proj_j = zeros(length(alpha_grp_j),1);
            proj_j(idxs) = simplexProject(alpha_grp_j(idxs)/C_grp_j);
            proj(slckGrp_j) = proj_j;
        end
    end    
end

% Computest the minimum L2-distance projection of vector v onto the probability simplex
% This function is copied from Mark Schmid MinConf package
% v: n*1 vector
% The optimization is:
%   min_w || w - v||^2, s.t., w_i >= 0, sum_i w_i = 1
function w = simplexProject(v)    
    nVars = length(v);
    mu = sort(v,'descend');
    sm = 0;
    for j = 1:nVars
        sm = sm+mu(j);
       if mu(j) - (1/j)*(sm-1) > 0
           row = j;
           sm_row = sm;
       end
    end
    theta = (1/row)*(sm_row-1);
    w = max(v-theta,0);
end
