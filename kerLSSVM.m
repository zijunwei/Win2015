% trD: d*n matrix for training data, each column is a FV, n is number of training instances
% trLb: 12*n label matrix for training data should be +1 and -1
% trLb(i,:) is binary lable vector for class i. trLb(i,j) is the label of video j for class i.
function aps = kerLSSVM(Lambda, trD, trLb, tstD, tstLb,classTxt)
    addpath('/Users/zijunwei/Dev/MatlabLibs/libsvm/matlab');
    trK = trD'*trD;
    tstK = tstD'*trD;
    
%     classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
%                     'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};

    fprintf('Train SVMs\n');                        
    % trK = [(1:size(trK,1))', trK]; 
    % tstK = [(1:size(tstK,1))', tstK];

    nAction = length(classTxt);
    aps = zeros(1, nAction);
    for i=1:nAction
        fprintf('training LSSVM model %d\n', i);
        trLb_i = trLb(i,:)'; 
        trLb_i(trLb_i == 0) = -1;

        tstLb_i = tstLb(i,:)'; 
        tstLb_i(tstLb_i == 0) = -1;                

        %model = libsvmtrain(trLb_i, trK, sprintf('-t 4 -c %g -q', Lambda));                
        %[~, ~, prob] = libsvmpredict(tstLb_i, tstK, model);
        
        % define s to be unique
        n=length(trLb_i);
        s=ones(n,1)/(n);
        Lambda0=Lambda*n;
        [alphas,b]=ML_Ridge. kerRidgeReg(trK,trLb_i,Lambda0,s);
        %prob = %prob*model.Label(1);      
        
        prob=tstK*alphas+b;
        aps(i) = ml_ap(prob, tstLb_i, 0);
    end;

    for i=1:nAction
        cls = classTxt{i};
        fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
    end
    fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));
end
