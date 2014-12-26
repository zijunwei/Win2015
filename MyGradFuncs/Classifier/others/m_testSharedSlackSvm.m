function m_testSharedSlackSvm()
    classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
                        'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};

    C = 0.1;
    actionSets = 1:2;
    [libSVM_aps, libSVM_objs, libSVM_time, ...
        libSVMlinear_aps, libSVMlinear_objs, libSVMlinear_time, ...
        minConf_aps, minConf_objs, minConf_time, ...
        minConfDual_aps, minConfDual_objs, minConfDual_time, ...
        sgd_aps, sgd_objs, sgd_time, ...
        asgd_aps, asgd_objs, asgd_time, ...
        cplex_aps, cplex_objs, cplex_time] = deal(zeros(1, length(classTxt)));

    load('m_data2testMinconf.mat', 'TrD', 'TstD', 'trLb', 'tstLb');
    
    % repmat to test speed
    TrD = repmat(TrD, [1,8]);
    trLb = repmat(trLb, [1, 8]);
    
    
    mapTrD = vl_homkermap(TrD, 1);
    mapTstD = vl_homkermap(TstD, 1);

    for i=actionSets
        fprintf('training SVM model %d\n', i);
        trLb_i = trLb(i,:)';
        trLb_i(trLb_i == 0)   = -1;
        

        tstLb_i = tstLb(i,:)';
        tstLb_i(tstLb_i == 0) = -1;

        tic;
        fprintf('training LibSVM kernel\n');        
        [w1, b1] = libSvm_precmpKernel(mapTrD, trLb_i, C);        
        libSVM_time(i) = toc;
        libSVM_aps(i) = getAp(mapTstD, tstLb_i, w1, b1);        
        libSVM_objs(i) = svmPrimalObj([w1;b1], mapTrD, trLb_i, C);
        % for mapTrD of dim 48000*20575, this takes 31 mins
        % for mapTrD of dim 48000*8230, this takes 5mins
        
        tic;
        fprintf('training minConf dual\n');
        [w2, b2, alpha, dualObj, primalObj, xi] = sharedSlackSVM(mapTrD, trLb_i, C, 'pqn');
        minConfDual_time(i) = toc;
        minConfDual_aps(i)  = getAp(mapTstD, tstLb_i, w2, b2);        
        minConfDual_objs(i) = svmPrimalObj([w2;b2], mapTrD, trLb_i, C);
        
        tic;
        fprintf('training minConf dual\n');
        [w2, b2, alpha, dualObj, primalObj, xi] = sharedSlackSVM(mapTrD, trLb_i, C, 'cplex');
        cplex_time(i) = toc;
        cplex_aps(i)  = getAp(mapTstD, tstLb_i, w2, b2);        
        cplex_objs(i) = svmPrimalObj([w2;b2], mapTrD, trLb_i, C);


        
        % for mapTrD of dim 48000*20575, max 1000 iters, this takes 36 mins, give better obj val than libSVM kernel
        % for mapTrD of dim 48000*8230, max 1000 iters, this takes 6.3mins, give better obj val than libSVM kernel
        
%         tic;
%         [w1, b1] = libSvm_linearKernel(mapTrD, trLb_i, C);        
%         libSVMlinear_time(i) = toc;
%         libSVMlinear_aps(i) = getAp(mapTstD, tstLb_i, w1, b1);        
%         libSVMlinear_objs(i) = svmPrimalObj([w1;b1], mapTrD, trLb_i, C);
        
        
%         tic;
%         [w, b] = svm_minConf(mapTrD, trLb_i, C);
%         minConf_time(i) = toc;
%         minConf_aps(i)  = getAp(mapTstD, tstLb_i, w, b);        
%         minConf_objs(i) = svmPrimalObj([w;b], mapTrD, trLb_i, C);
        
        
%         lambda = 1/C/size(TrD,2);
%         tic;
%         [w,b]= ML_SvmSgd.train(mapTrD, trLb_i, lambda, 500, 1);
%         sgd_time(i) = toc;
%         sgd_aps(i) = getAp(mapTstD, tstLb_i, w, b);
%         sgd_objs(i) = svmPrimalObj([w;b], mapTrD, trLb_i, C);
%         
%         [w,b]= ML_SvmAsgd.train(mapTrD, trLb_i, lambda, 500, 1);
%         asgd_time(i) = toc;
%         asgd_aps(i) = getAp(mapTstD, tstLb_i, w, b);
%         asgd_objs(i) = svmPrimalObj([w;b], mapTrD, trLb_i, C);

        cls = classTxt{i};
        fprintf('%-11s,   %8s, %8s, %8s, %8s, %8s, %8s, %8s\n', cls, 'libSVM', 'libSVM-l', 'minConf', 'PQNDual', 'Cplex', 'sgd', 'asgd');
        fprintf('\t ap:   %8.2f, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f\n', ...
            100*libSVM_aps(i), 100*libSVMlinear_aps(i), 100*minConf_aps(i), 100*minConfDual_aps(i), 100*cplex_aps(i), 100*sgd_aps(i), 100*asgd_aps(i));
        fprintf('\t obj:  %8.3f, %8.3f, %8.3f, %8.3f, %8.3f, %8.3f, %8.3f\n', ...
            libSVM_objs(i), libSVMlinear_objs(i), minConf_objs(i), minConfDual_objs(i), cplex_objs(i), sgd_objs(i), asgd_objs(i));
        fprintf('\t time: %8.1f, %8.1f, %8.1f, %8.1f, %8.1f, %8.1f, %8.1f\n', ...            
            libSVM_time(i), libSVMlinear_time(i), minConf_time(i), minConfDual_time(i), cplex_time(i), sgd_time(i), asgd_time(i));
    end;
    
    for i=actionSets
        cls = classTxt{i};
        fprintf('%-11s,   %8s, %8s, %8s, %8s, %8s, %8s, %8s\n', cls, 'libSVM', 'libSVM-l', 'minConf', 'PQNDual', 'Cplex', 'sgd', 'asgd');
        fprintf('\t ap:   %8.2f, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f\n', ...
            100*libSVM_aps(i), 100*libSVMlinear_aps(i), 100*minConf_aps(i), 100*minConfDual_aps(i), 100*cplex_aps(i), 100*sgd_aps(i), 100*asgd_aps(i));
        fprintf('\t obj:  %8.3f, %8.3f, %8.3f, %8.3f, %8.3f, %8.3f, %8.3f\n', ...
            libSVM_objs(i), libSVMlinear_objs(i), minConf_objs(i), minConfDual_objs(i), cplex_objs(i), sgd_objs(i), asgd_objs(i));
        fprintf('\t time: %8.1f, %8.1f, %8.1f, %8.1f, %8.1f, %8.1f, %8.1f\n', ...            
            libSVM_time(i), libSVMlinear_time(i), minConf_time(i), minConfDual_time(i), cplex_time(i), sgd_time(i), asgd_time(i));
    end;
    
function [w, b] = svm_minConf(trD, trLb, C, initw, initb)
    d = size(trD, 1);        
    LB = -inf(d+1,1);     
    UB = inf(d+1,1);
    funObj = @(wb)svmPrimalObj(wb, trD, trLb, C);
    
    if exist('initw', 'var') && exist('initb', 'var')
        wb_init = [initw; initb];
    else
        %wb_init = zeros(d+1,1);
        wb_init = trD*trLb;
        
        % find the scale factor
        a = trLb.*(trD'*wb_init); % values for: y_i*w'*x_i
        % we want a scale factor so that each entry of a is close to 1 as much as possible
        alpha = sum(a)/sum(a.^2);
        wb_init = wb_init*alpha;        
        wb_init(end+1) = 0;
    end
    
    options = [];
    options.maxIter = 2000;
    options.verbose = 1;
    wb = minConf_TMP(funObj,wb_init,LB,UB,options);
    
%     options.Method = 'lbfgs';
%     wb = minFunc(funObj,wb_init,options);

    w = wb(1:d);
    b = wb(end);
    
function [w,b, alpha, dualObj, primalObj, xi] = sharedSlackSVM(trD, trLb, C, optMethod)    
    if strcmpi(optMethod, 'pqn')
        options = [];
        options.verbose = 1;
        options.maxIter = 2000;
        fprintf('max iter %g\n', options.maxIter);
        [w, b, alpha, dualObj, primalObj, xi] = ML_ShareSlackSvm.linearSvm(trD, trLb, {}, C, 'pqn', [], options, 1);
    elseif strcmpi(optMethod, 'cplex')
        [w, b, alpha, dualObj, primalObj, xi] = ML_ShareSlackSvm.linearSvm(trD, trLb, {}, C, 'cplex', [], 1);
    end
    
% compute SVM primal objective
% wb: weight vector with bias term at the end
% lb: label vector of 1, -1
function [f,g] = svmPrimalObj(wb, D, lb, C)

w = wb(1:end-1);
svmScore = D'*w + wb(end); 

xi = max(0, 1 - lb.*svmScore);
idxs = xi > 0;

f = 0.5*(w'*w) + C*sum(xi);
gw = w - C*D(:, idxs)*lb(idxs);
gb = - C*sum(lb(idxs));
g = [gw; gb];


    
function [w, b] = libSvm_linearKernel(trD, lb, C)        
    svmModel = svmtrain(lb, trD', sprintf('-t 0 -c %g -q', C));    
    b = - svmModel.rho*svmModel.Label(1);
    w = svmModel.SVs'*svmModel.sv_coef*svmModel.Label(1);


function [w, b] = libSvm_precmpKernel(trD, lb, C)
    trK = [(1:length(lb))', trD'*trD];

    svmModel = svmtrain(lb, trK, sprintf('-t 4 -c %g -q', C));
    sv_coef = zeros(length(lb), 1);
    sv_coef(svmModel.SVs) = svmModel.sv_coef;
    b = - svmModel.rho*svmModel.Label(1);
    w = trD*sv_coef*svmModel.Label(1);

function ap = getAp(tstD, lb, w, b)    
    svmScore = tstD'*w + b;
    ap = ml_ap(svmScore, lb, 0);

