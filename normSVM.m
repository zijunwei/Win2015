% trD: d*n matrix for training data, each column is a FV, n is number of training instances
% trLb: 12*n label matrix for training data
% trLb(i,:) is binary lable vector for class i. trLb(i,j) is the label of video j for class i.
function aps = normSVM(C, trD, trLb, tstD, tstLb,classTxt)
    addpath('/Users/zijunwei/Dev/MatlabLibs/libsvm/matlab');
    trK = trD'*trD;
    tstK = tstD'*trD;
    
%     classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
%                     'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};

    fprintf('Train SVMs\n');                        
    trK = [(1:size(trK,1))', trK]; 
    tstK = [(1:size(tstK,1))', tstK];

    nAction = length(classTxt);
    aps = zeros(1, nAction);
    for i=1:nAction
        fprintf('training SVM model %d\n', i);
        trLb_i = trLb(i,:)'; 
        trLb_i(trLb_i == 0) = -1;

        tstLb_i = tstLb(i,:)'; 
        tstLb_i(tstLb_i == 0) = -1;                

        model = libsvmtrain(trLb_i, trK, sprintf('-t 4 -c %g -q', C));                
        [~, ~, prob] = libsvmpredict(tstLb_i, tstK, model);
        prob = prob*model.Label(1);                
        aps(i) = ml_ap(prob, tstLb_i, 0);
    end;

    for i=1:nAction
        cls = classTxt{i};
        fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
    end
    fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));
end
