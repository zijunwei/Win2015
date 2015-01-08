function [model, objVal] = ml_LSVM_cplex(parm)
% function [model, objVal] = ml_LSVM_cplex(parm)
% Given positive traing bags {x_i} and negative training bags {z_i}, this function finds the
% positive instances in the positive bags and divide them into k clusters. Each cluster is
% parameterized by weight vector w_j and a bias term b_j. This optimizes:
%   min_{w_j, b_j, alpha_i, beta_i} 0.5*sum_j (||w_j||^2) + C*sum_i alpha_i + C*sum_i beta_i
%   s.t.
%       max_{j, h} w_j'*phi(x_i, h) + b_j >=  1 - alpha_i \forall i,
%       max_{j, h} w_j'*phi(z_i, h) + b_j <= -1 + beta_i  \forall i,
%       alpha_i, beta_i >= 0.
% This function uses QP of CPlex for optimization
% Inputs: 
%   parm is a structure with the the required fileds:
%     dimension: the # dims of feature vector, weight vector
%     nMixture: number of clusters for positive data
%     posD: a 1*nPos cell for nPos positive training examples
%     negD: a 1*nNeg cell for nNeg negative training examples
%     C: for C-SVM
%     initWs: initial weight matrix
%   parm must have one call-back function:
%     [desc, mixtureId] = featureFn(model, parm, x);
%        with x is a traiing example
% Outputs:
%   model.Ws: dimension*nMixture for weight vector
%   model.bs: nMixture for the bias term
%   model.xi: a vector of length (nPos + nNeg) for the slack variables
% By Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Date 25/3/12

[model, objVal] = coordinateDescent(parm);

% Coordinate descent optimization with multiple restart
% parm.initWs and parm.initBs are cell arrays that contain initial starting configuration
function [bestModel, bestObjVal, models] = coordinateDescent(parm)
    NO_MAX_ITER = 50;
    OBJ_TOLFAC = 1e-3;
    verbose = parm.verbose;

    nRestart = length(parm.initWs);
    
    models = cell(1, nRestart);
    objVals = zeros(1, nRestart);

    for i=1:nRestart    
        model.Ws = parm.initWs{i};
        model.bs = parm.initBs{i};

        curObjVal = inf;
        for iter=1:NO_MAX_ITER
            if (verbose >= 3) 
                fprintf('  CD iter: %d, curObjVal: %g\n', iter, curObjVal); 
            end;
            [model, objVal] = constrGenStep(parm, model);
            if objVal > (1-OBJ_TOLFAC)*curObjVal
                break;
            end;
            curObjVal = objVal;
        end
        if (verbose >= 2)
            fprintf('  Restart %d/%d summary, #iters: %d, objVal: %g\n', i, nRestart, iter, objVal);
        end
        models{i} = model;
        objVals(i) = objVal;
    end
    
    [bestObjVal, bestRunId] = min(objVals);
    bestModel = models{bestRunId};
    
    if (verbose >= 1)
        fprintf('objVals for all restarts: '); fprintf('%.3f ', objVals); fprintf('\n');
        fprintf('objVals, best : %.3f, worst: %.3f, median: %.3f\n', ...
            bestObjVal, max(objVals), median(objVals));
    end;


% Do constraint generation step: fix the positive instances in the positive bags
% Optimize the parameters with all instances in the negative bags
function [model, objVal] = constrGenStep(parm, model)
    NO_MAX_ITER = 50;
    DUALGAP_TOLFAC = 1e-3; % stops if duality- gap < tolFac*objVal
    INACTIVE_TOL   = 1e-5; % if a constraint is well satisified (by this tol), it will be removed.

    d = parm.dimension;
    k = parm.nMixture;
    nPos = length(parm.posD);
    nNeg = length(parm.negD);
    n = nPos + nNeg;
    C = parm.C; 

    dk = d*k;
    dkk = dk + k;
    dkkn = dkk + n;

    verbose = parm.verbose;

    % variable x = [w, b, xi];
    cplex = Cplex('MCMISVM_cplex');
    cplex.Model.sense = 'minimize';

    % Add objective: 0.5*x'*Q*x
    Q = spalloc(dkkn, dkkn, dk); % allocate dk non-zero entry for Q
    for i=1:dk
        Q(i,i) = 1;
    end;
    cplex.Model.Q = Q;

    % Add linear part of the objective
    obj = zeros(dkkn,1);
    obj(dkk+1:end) = C/n;
    % cplex.Model.obj = obj; % doesn't work
    cplex.addCols(sparse(obj));

    % Add constraint: xi_i >= 0
    lb = zeros(dkkn, 1);
    lb(1:dkk) = -inf;
    cplex.Model.lb = lb;

    % Callback function for display
    cplex.DisplayFunc = []; %@disp;

    % Add constraints for positive training examples
    xi_sum = 0;
    for i=1:nPos
        [desc, mixtureID] = parm.featureFn(model, parm, parm.posD{i});
        constrVec = zeros(1, dkkn);
        constrVec(1+(mixtureID-1)*d:mixtureID*d) =  desc; 
        constrVec(dk + mixtureID) = 1; % for b
        constrVec(dkk + i) = 1; % for xi
        cplex.addRows(1, sparse(constrVec), inf);  % w'*feat + b + xi >= 1  

        xi = 1 - (model.Ws(:,mixtureID)'*desc + model.bs(mixtureID));

        if xi > 0 % one more violated constraint
            xi_sum = xi_sum + xi; 
        end;
    end;

    model.xi = zeros(n,1);
    objUb = inf;
    objVal = 0.5*sum(model.Ws(:).^2) + (C/n)*xi_sum; % inital objective value

    for iter=1:NO_MAX_ITER
        if (verbose >= 5)
            fprintf('      ConstrGen iter %d\n', iter);
        end;
        nNewConstr = 0;
        newVio = 0;

        for i=1:nNeg
            [mvcDesc, mixtureID] = parm.featureFn(model, parm, parm.negD{i});
            newxi = model.Ws(:,mixtureID)'*mvcDesc + model.bs(mixtureID) + 1;

            if newxi > model.xi(nPos + i) % one more violated constraint
                newVio = newVio + (newxi - model.xi(nPos + i));
                nNewConstr = nNewConstr + 1;
                constrVec  = zeros(1, dkkn);        
                constrVec(1+(mixtureID-1)*d:mixtureID*d) =  - mvcDesc; % for w
                constrVec(dk + mixtureID) = -1; % for b
                constrVec(dkk + nPos+ i) = 1;   % for xi
                % -w'*feat -b + xi >= 1 or w'*feat + b <= -1 + xi
                cplex.addRows(1, sparse(constrVec), inf);        
            end;
        end;    

        % Check if it converges
        ub = objVal + (C/n)*newVio; % upper bound of the objective
        objUb = min(ub, objUb);

        gap = objUb - objVal;

        if (gap < -1e-5)
            keyboard;
        end;

        if verbose >= 5
            fprintf('      nNewCnstr/totalCnstr: %d/%d, obj: %g, objUb: %g, gap: %g\n', ...
                nNewConstr, size(cplex.Model.A,1), objVal, objUb, gap);
        end
        if gap < objVal*DUALGAP_TOLFAC && iter > 1, 
            break; 
        end;               

        % Solve the QP
        cplex.solve();
        x = cplex.Solution.x;    
        model.Ws = reshape(x(1:dk), d, k);
        model.bs = x(dk+1:dkk);
        model.xi = x(dkk+1:end);
        objVal   = cplex.Solution.objval;             

        % Remove inactive constraints
        cnstrSat = cplex.Solution.ax - cplex.Model.lhs; % constraint satisfaction
        inactiveCnstrs = find(cnstrSat > INACTIVE_TOL); % not tight, inactive constraints

        cnstr2remove = inactiveCnstrs(inactiveCnstrs > nPos); % only remove negative constraints

        if ~isempty(cnstr2remove)
            if verbose >= 5
                fprintf('      remove %d inactive constraints, remain: %d\n', ...
                    length(cnstr2remove), size(cplex.Model.A,1) - length(cnstr2remove));
            end
            cplex.delRows(cnstr2remove); %#ok<FNDSB>
        end    
    end;

    if verbose >= 4
        fprintf('      ConstrGen summary: #iters: %d, objVal: %g, #cnstrs: %d\n', iter, objVal, size(cplex.Model.A,1));
    end
