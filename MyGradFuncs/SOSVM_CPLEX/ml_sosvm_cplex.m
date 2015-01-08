function model = ml_sosvm_cplex(parm)
% function model = m_SOSVM_cplex(parm)
% Use QP of CPlex for SOSVM
% Inputs: 
%   parm is a structure with the the required fileds:
%     dimension: the # dims of feature vector, weight vector
%     patterns: a 1*n cell for n training examles
%     labels: a 1*n cell for n structure-output labels.
%     C: for C-SVM
%   parm must have three functions:
%     yhat = constraintFn(parm, model, x, y);
%     desc = featureFn(parm, x, y);
%     loss = lossFn(parm, x, yhat);
%     with x is a traiing example and y is a label.
%   parm can have optional fields:
%     instanceW: 1*n non-negative vector for instance weight, default ones(1,n).
%     biasIdxs: indexes of the bias weights in the SVM vector w. 
%       The objective is to minize 0.5*sum_(i not in biasIdxs) ||w_i||^2
% Outputs:
%   model.w: for weight vector
%   model.xi: for the slack variables
% By Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Date 28/2/12


NO_MAX_ITER = 50;
DUALGAP_TOLFAC = 1e-3; % stops if duality- gap < tolFac*objVal
INACTIVE_TOL = 1e-5; % if a constraint is well satisified (by this tol), it will be removed.

d = parm.dimension;
n = length(parm.patterns);
C = parm.C; 

if isfield(parm, 'instanceW')
    instanceW = parm.instanceW;
    if length(instanceW) ~= n
        error('length(parm.instanceW) must be the same with length(parm.labels)');
    end;
else
    instanceW = ones(n, 1);
end;

if isfield(parm, 'biasIdxs')
    biasIdxs = parm.biasIdxs;
else
    biasIdxs = [];
end;


% variable x = [w, xi];
cplex = Cplex('SOSVM_cplex');
cplex.Model.sense = 'minimize';

% Add objective: 0.5*x'*Q*x
Q = sparse(d+n, d+n);
onetod = 1:d;
onetod(biasIdxs) = [];
linIdxs = sub2ind(size(Q), onetod, onetod);
Q(linIdxs) = 1;
cplex.Model.Q = Q;

% Add linear part of the objective
obj = zeros(d+n,1);
obj(d+1:end) = C/n*instanceW;
% cplex.Model.obj = obj; % doesn't work
cplex.addCols(sparse(obj));

% Add constriant: xi_i >= 0
lb = zeros(d+n, 1);
lb(1:d) = -inf;
cplex.Model.lb = lb;

% Call back function for display
cplex.DisplayFunc = []; %@disp;

gtDescs = zeros(d, n);
for i=1:n
    gtDescs(:,i) = parm.featureFn(parm, parm.patterns{i}, parm.labels{i});
end;

model.w = zeros(d,1); %initial w
model.xi = zeros(n, 1);
objUb = inf;
objVal = 0;

for iter=1:NO_MAX_ITER
    fprintf('->Running iter %d\n', iter);
    nNewConstr = 0;
    newVio = 0;
    for i=1:n
        yhat = parm.constraintFn(parm, model, parm.patterns{i}, parm.labels{i});
        mvcDesc = parm.featureFn(parm, parm.patterns{i}, yhat);
        loss = parm.lossFn(parm, parm.labels{i}, yhat);
        
        newxi = loss*(model.w'*(mvcDesc - gtDescs(:,i)) + 1);
        
        if newxi > model.xi(i) % one more violated constraint
            newVio = newVio + instanceW(i)*(newxi - model.xi(i));
            nNewConstr = nNewConstr + 1;
            constrVec = zeros(1, d+ n);        
            constrVec(1:d) = loss*(gtDescs(:,i) - mvcDesc);
            constrVec(d + i) = 1;        
            cplex.addRows(loss, sparse(constrVec), inf);        
        end;
    end;    
    
    % Check if converge
    ub = objVal + (C/n)*newVio; % upperbound of the objective
    objUb = min(ub, objUb);
    
    gap = objUb - objVal;
    fprintf('--->iter %d, nNewCnstr/totalCnstr: %d/%d, obj: %g, objUb: %g, gap: %g\n', ...
        iter, nNewConstr, size(cplex.Model.A,1), objVal, objUb, gap);
    if gap < objVal*DUALGAP_TOLFAC, break; end;               
    
    % Solve the QP
    cplex.solve();
    x = cplex.Solution.x;    
    model.w = x(1:d);
    model.xi = x(d+1:end);
    objVal = cplex.Solution.objval;             
    
    % Remove inactive constraints
    cnstrSat = cplex.Solution.ax - cplex.Model.lhs; % constraint satisfaction
    inactiveCnstrs = find(cnstrSat > INACTIVE_TOL); % not tight, inactive constraints
    if ~isempty(inactiveCnstrs)
        fprintf('--->iter %d, remove %d inactive constraints, remain: %d\n', ...
            iter, length(inactiveCnstrs), size(cplex.Model.A,1) - length(inactiveCnstrs));
        cplex.delRows(inactiveCnstrs); %#ok<FNDSB>
    end    
end;

fprintf('====> #iters: %d, objVal: %g, #cnstrs: %d\n', iter, objVal, size(cplex.Model.A,1));
