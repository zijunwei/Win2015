% test degenerate situations:
% test if all the original vectors are degnerate
function degenerate_check
addpath('./ActionMat/')

classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};

for i=1:1:length(classTxt)
    load(sprintf('%s_arg_neg_l2.mat',classTxt{i}));
    trK=trD*trD';
    isCond=Zj_MatrixChecking.iscondition(trK);
    if isCond
        
        warning('%s is in bad condition\n',classTxt{i});
    else
        warning('%s is good!\n',classTxt{i});
    end
         pn_condi(1,trD,classTxt{i},trLb);
         pn_condi(-1,trD,classTxt{i},trLb);
    
end

end
function  pn_condi(pn,trD,txt,trLb)


pos_ind= trLb==pn;
trD_pos=trD(pos_ind,:);
trK_pos=trD_pos*trD_pos';

isCond=Zj_MatrixChecking.iscondition(trK_pos);
if isCond
    if pn
        warning('%s pos is in bad condition',txt);
    else
        warning('%s neg is in bad condition',txt);
    end
end
end